import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

// Local persistence service for wishlist items scoped by user
class WishlistStorageService {
  WishlistStorageService({this.prefs});

  static const _legacyKey = 'shopease_wishlist_items';
  final SharedPreferences? prefs;

  Future<SharedPreferences> _getPrefs() async =>
      prefs ?? await SharedPreferences.getInstance();

  String _buildKey(String? userId) => (userId != null && userId.isNotEmpty)
      ? 'shopease_wishlist_$userId'
      : 'shopease_wishlist_guest';

  // Load Wishlist Items
  Future<List<ProductModel>> loadWishlist({String? userId}) async {
    try {
      final preferences = await _getPrefs();
      final key = _buildKey(userId);
      var jsonString = preferences.getString(key);

      if ((jsonString == null || jsonString.isEmpty) &&
          (userId == null || userId.isEmpty)) {
        final legacyString = preferences.getString(_legacyKey);
        if (legacyString != null && legacyString.isNotEmpty) {
          jsonString = legacyString;
          await preferences.setString(key, legacyString);
          await preferences.remove(_legacyKey);
        }
      }

      if (jsonString == null || jsonString.isEmpty) return [];

      final list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Save wishlist items
  Future<void> saveWishlist(List<ProductModel> items, {String? userId}) async {
    try {
      final preferences = await _getPrefs();
      final key = _buildKey(userId);
      if (items.isEmpty) {
        await preferences.remove(key);
      } else {
        final list = items.map((i) => i.toMap()).toList();
        await preferences.setString(key, jsonEncode(list));
      }
    } catch (_) {}
  }

  // Clear persisted wishlist
  Future<void> clearWishlist({String? userId}) async {
    try {
      final preferences = await _getPrefs();
      await preferences.remove(_buildKey(userId));
    } catch (_) {}
  }
}
