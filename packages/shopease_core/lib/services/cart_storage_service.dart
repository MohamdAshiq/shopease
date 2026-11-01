import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';

// Local persistence service for cart items
class CartStorageService {
  CartStorageService({this.prefs});

  static const _key = 'shopease_cart_items';
  final SharedPreferences? prefs;

  Future<SharedPreferences> _getPrefs() async =>
      prefs ?? await SharedPreferences.getInstance();

  // Load Cart Items
  Future<List<CartItemModel>> loadCart() async {
    try {
      final preferences = await _getPrefs();
      final jsonString = preferences.getString(_key);
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
  Future<void> saveCart(List<CartItemModel> items) async {
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

  // Clear persisted cart from local storage
  Future<void> clearCart() async {
    final preferences = await _getPrefs();
    await preferences.remove(_key);
  }
}
