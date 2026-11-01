import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

// Local persistence service for wishlist items
class WishlistStorageService {
  WishlistStorageService({this.prefs});

  static const _key = 'shopease_wishlist_items';
  final SharedPreferences? prefs;

  Future<SharedPreferences> _getPrefs() async =>
      prefs ?? await SharedPreferences.getInstance();

  // Load Wishlist Items
  Future<List<ProductModel>> loadWishlist() async {
    try {
      final preferences = await _getPrefs();
      final jsonString = preferences.getString(_key);
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
  Future<void> saveWishlist(List<ProductModel> items) async {
    try {
      final preferences = await _getPrefs();
      if (items.isEmpty) {
        await preferences.remove(_key);
      } else {
        final list = items.map((i) => i.toMap()).toList();
        await preferences.setString(_key, jsonEncode(list));
      }
    } catch (_) {}
  }

  // Clear persisted wishlist
  Future<void> clearWishlist() async {
    final preferences = await _getPrefs();
    await preferences.remove(_key);
  }
}
