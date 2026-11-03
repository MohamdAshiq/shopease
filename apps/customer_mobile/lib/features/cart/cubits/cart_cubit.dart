import 'package:shopease_core/shopease_core.dart';

import 'cart_state.dart';

// Result of an addToCart operation
enum AddToCartResult { success, maxStockReached, outOfStock }

// Cubit managing user-scoped shopping cart with Firestore synchronization
class CartCubit extends Cubit<CartState> {
  CartCubit({
    UserModel? initialUser,
    List<CartItemModel>? initialItems,
    CartStorageService? storageService,
    FirebaseFirestore? firestore,
  }) : _currentUser = initialUser,
       _customFirestore = firestore,
       _storageService = storageService ?? CartStorageService(),
       super(CartState(items: initialItems ?? const [])) {
    if (initialItems == null) {
      _loadSavedCart();
    }
  }

  static const int defaultMaxStock = 99;

  final CartStorageService _storageService;
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

  Future<void> _loadSavedCart() async {
    final saved = await _storageService.loadCart(userId: _currentUser?.uid);
    if (!isClosed && saved.isNotEmpty) {
      emit(state.copyWith(items: saved));
    }
  }

  // Update current customer and synchronize user-scoped cart
  Future<void> setCustomer(UserModel? user) async {
    if (_currentUser?.uid == user?.uid) return;
    _currentUser = user;

    if (user == null) {
      // Switched to guest mode: load local guest cart
      final guestItems = await _storageService.loadCart(userId: null);
      if (!isClosed) {
        emit(state.copyWith(items: guestItems));
      }
      return;
    }

    // Authenticated user logged in
    final guestItems = await _storageService.loadCart(userId: null);
    final userLocalItems = await _storageService.loadCart(userId: user.uid);
    List<CartItemModel> cloudItems = [];
    try {
      final firestore = _firestore;
      if (firestore != null) {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['cart'] is List) {
            cloudItems = (data['cart'] as List)
                .whereType<Map<String, dynamic>>()
                .map(CartItemModel.fromMap)
                .toList();
          }
        }
      }
    } catch (_) {}

    var merged = _mergeCartLists(cloudItems, userLocalItems);
    merged = _mergeCartLists(merged, guestItems);

    if (isClosed) return;
    emit(state.copyWith(items: merged));

    await _storageService.saveCart(merged, userId: user.uid);

    _syncToFirestore(merged, user.uid);

    if (guestItems.isNotEmpty) {
      await _storageService.clearCart(userId: null);
    }
  }

  List<CartItemModel> _mergeCartLists(
    List<CartItemModel> base,
    List<CartItemModel> incoming,
  ) {
    final result = List<CartItemModel>.from(base);
    for (final inc in incoming) {
      final index = result.indexWhere((item) => item.id == inc.id);
      if (index != -1) {
        final existing = result[index];
        final maxStock = inc.product.stock > 0
            ? inc.product.stock
            : defaultMaxStock;
        final combinedQty = (existing.quantity + inc.quantity).clamp(
          1,
          maxStock,
        );
        result[index] = existing.copyWith(quantity: combinedQty);
      } else {
        result.add(inc);
      }
    }
    return result;
  }

  void _saveCart() {
    _storageService.saveCart(state.items, userId: _currentUser?.uid);
    if (_currentUser != null) {
      _syncToFirestore(state.items, _currentUser!.uid);
    }
  }

  Future<void> _syncToFirestore(List<CartItemModel> items, String uid) async {
    try {
      final firestore = _firestore;
      if (firestore == null) return;

      final cartMaps = items.map((e) => e.toMap()).toList();
      await firestore.collection('users').doc(uid).set({
        'cart': cartMaps,
        'cartUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  // Add product to cart or increment quantity if already present
  AddToCartResult addToCart(
    ProductModel product, {
    String selectedSize = '',
    int quantity = 1,
  }) {
    if (!product.isInStock) {
      return AddToCartResult.outOfStock;
    }

    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id && item.selectedSize == selectedSize,
    );

    final updatedItems = List<CartItemModel>.from(state.items);

    if (existingIndex != -1) {
      final existing = updatedItems[existingIndex];
      if (existing.quantity >= product.stock) {
        return AddToCartResult.maxStockReached;
      }
      final newQuantity = (existing.quantity + quantity).clamp(
        1,
        product.stock,
      );
      updatedItems[existingIndex] = existing.copyWith(quantity: newQuantity);
    } else {
      updatedItems.add(
        CartItemModel(
          product: product,
          selectedSize: selectedSize,
          quantity: quantity.clamp(1, product.stock),
        ),
      );
    }

    emit(state.copyWith(items: updatedItems));
    _saveCart();
    return AddToCartResult.success;
  }

  // Undo Option
  void restoreItem(int index, CartItemModel item) {
    final updatedItems = List<CartItemModel>.from(state.items);
    final clampedIndex = index.clamp(0, updatedItems.length);
    updatedItems.insert(clampedIndex, item);
    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Update item quantity
  void updateQuantity(String productId, String selectedSize, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId, selectedSize);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId && item.selectedSize == selectedSize) {
        final clampedQty = quantity.clamp(1, item.product.stock);
        return item.copyWith(quantity: clampedQty);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Increment item quantity
  void incrementQuantity(String productId, String selectedSize) {
    final index = state.items.indexWhere(
      (i) => i.product.id == productId && i.selectedSize == selectedSize,
    );
    if (index == -1) return;
    updateQuantity(productId, selectedSize, state.items[index].quantity + 1);
  }

  // Decrement item quantity
  void decrementQuantity(String productId, String selectedSize) {
    final index = state.items.indexWhere(
      (i) => i.product.id == productId && i.selectedSize == selectedSize,
    );
    if (index == -1) return;
    updateQuantity(productId, selectedSize, state.items[index].quantity - 1);
  }

  // Remove a specific line item
  void removeFromCart(String productId, String selectedSize) {
    final updatedItems = state.items.where((item) {
      return !(item.product.id == productId &&
          item.selectedSize == selectedSize);
    }).toList();

    emit(state.copyWith(items: updatedItems));
    _saveCart();
  }

  // Clear all items from cart
  void clearCart() {
    emit(const CartState(items: []));
    _saveCart();
  }
}
