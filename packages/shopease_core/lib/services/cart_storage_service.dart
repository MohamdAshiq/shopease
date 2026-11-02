import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';

// Local persistence service for cart items scoped by user
class CartStorageService {
  CartStorageService({this.prefs});

  static const _legacyKey = 'shopease_cart_items';
  final SharedPreferences? prefs;

  Future<SharedPreferences> _getPrefs() async =>
      prefs ?? await SharedPreferences.getInstance();

  String _buildKey(String? userId) => (userId != null && userId.isNotEmpty)
      ? 'shopease_cart_$userId'
      : 'shopease_cart_guest';

  // Load Cart Items
  Future<List<CartItemModel>> loadCart({String? userId}) async {
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
          .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Save cart items to local storage
  Future<void> saveCart(List<CartItemModel> items, {String? userId}) async {
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

  // Clear persisted cart from local storage
  Future<void> clearCart({String? userId}) async {
    try {
      final preferences = await _getPrefs();
      await preferences.remove(_buildKey(userId));
    } catch (_) {}
  }
}
