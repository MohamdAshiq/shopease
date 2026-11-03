import 'package:shopease_core/shopease_core.dart';

import 'wishlist_state.dart';

// Cubit managing user-scoped wishlist with Firestore synchronization
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit({
    UserModel? initialUser,
    List<ProductModel>? initialItems,
    WishlistStorageService? storageService,
    FirebaseFirestore? firestore,
  }) : _currentUser = initialUser,
       _customFirestore = firestore,
       _storageService = storageService ?? WishlistStorageService(),
       super(WishlistState(items: initialItems ?? const [])) {
    if (initialItems == null) {
      _loadSavedWishlist();
    }
  }

  final WishlistStorageService _storageService;
  final FirebaseFirestore? _customFirestore;
  UserModel? _currentUser;

  FirebaseFirestore? get _firestore {
    if (_customFirestore != null) return _customFirestore;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  UserModel? get currentUser => _currentUser;

  Future<void> _loadSavedWishlist() async {
    final saved = await _storageService.loadWishlist(userId: _currentUser?.uid);
    if (!isClosed && saved.isNotEmpty) {
      emit(state.copyWith(items: saved));
    }
  }

  // Update current customer and synchronize user-scoped wishlist
  Future<void> setCustomer(UserModel? user) async {
    if (_currentUser?.uid == user?.uid) return;
    _currentUser = user;

    if (user == null) {
      // Switched to guest mode: load local guest wishlist
      final guestItems = await _storageService.loadWishlist(userId: null);
      if (!isClosed) {
        emit(state.copyWith(items: guestItems));
      }
      return;
    }

    // Authenticated user logged in
    final guestItems = await _storageService.loadWishlist(userId: null);
    final userLocalItems = await _storageService.loadWishlist(userId: user.uid);

    List<ProductModel> cloudItems = [];
    try {
      final firestore = _firestore;
      if (firestore != null) {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['wishlist'] is List) {
            cloudItems = (data['wishlist'] as List)
                .whereType<Map<String, dynamic>>()
                .map(ProductModel.fromMap)
                .toList();
          }
        }
      }
    } catch (_) {}

    final merged = <ProductModel>[];
    final seenIds = <String>{};
    void addList(List<ProductModel> list) {
      for (final p in list) {
        if (seenIds.add(p.id)) {
          merged.add(p);
        }
      }
    }

    addList(guestItems);
    addList(userLocalItems);
    addList(cloudItems);

    if (isClosed) return;
    emit(state.copyWith(items: merged));

    await _storageService.saveWishlist(merged, userId: user.uid);

    _syncToFirestore(merged, user.uid);

    if (guestItems.isNotEmpty) {
      await _storageService.clearWishlist(userId: null);
    }
  }

  void _saveWishlist() {
    _storageService.saveWishlist(state.items, userId: _currentUser?.uid);
    if (_currentUser != null) {
      _syncToFirestore(state.items, _currentUser!.uid);
    }
  }

  Future<void> _syncToFirestore(List<ProductModel> items, String uid) async {
    try {
      final firestore = _firestore;
      if (firestore == null) return;

      final wishlistMaps = items.map((i) => i.toMap()).toList();
      final wishlistIds = items.map((i) => i.id).toList();

      await firestore.collection('users').doc(uid).set({
        'wishlist': wishlistMaps,
        'wishlistProductIds': wishlistIds,
        'wishlistUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  // Sets the active filter for the wishlist
  void setFilter(WishlistFilter filter) {
    if (state.selectedFilter == filter) return;
    emit(state.copyWith(selectedFilter: filter));
  }

  // Toggles wishlist value
  bool toggleWishlist(ProductModel product) {
    if (state.isFavorite(product.id)) {
      removeFromWishlist(product.id);
      return false;
    } else {
      addToWishlist(product);
      return true;
    }
  }

  // Adds a product to the wishlist
  void addToWishlist(ProductModel product) {
    if (state.isFavorite(product.id)) return;
    final updatedList = List<ProductModel>.from(state.items)
      ..insert(0, product);
    emit(state.copyWith(items: updatedList));
    _saveWishlist();
  }

  // Removes a product from the wishlist
  void removeFromWishlist(String productId) {
    if (!state.isFavorite(productId)) return;
    final updatedList = state.items
        .where((product) => product.id != productId)
        .toList();
    emit(state.copyWith(items: updatedList));
    _saveWishlist();
  }

  // Clears all items from the wishlist
  void clearWishlist() {
    if (state.isEmpty) return;
    emit(const WishlistState(items: []));
    _storageService.clearWishlist(userId: _currentUser?.uid);
    if (_currentUser != null) {
      _syncToFirestore(const [], _currentUser!.uid);
    }
  }
}
