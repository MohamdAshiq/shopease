import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../models/product_model.dart';

// Each Category item
class CategoryItem {
  const CategoryItem({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

// App Categories
abstract final class AppCategories {
  static const all = 'All';
  static const electronics = 'Electronics';
  static const footwear = 'Footwear';
  static const accessories = 'Accessories';
  static const gaming = 'Gaming';
  static const homeAndKitchen = 'Home & Kitchen';

  // Base preset category names
  static const List<String> defaultNames = [
    all,
    electronics,
    footwear,
    accessories,
    gaming,
    homeAndKitchen,
  ];

  // Backward-compatible alias
  static List<String> get names => defaultNames;

  static const List<CategoryItem> defaultItems = [
    CategoryItem(name: all, icon: IconsaxPlusLinear.category),
    CategoryItem(name: electronics, icon: IconsaxPlusLinear.headphone),
    CategoryItem(name: footwear, icon: IconsaxPlusLinear.tag),
    CategoryItem(name: accessories, icon: IconsaxPlusLinear.watch),
    CategoryItem(name: gaming, icon: IconsaxPlusLinear.game),
    CategoryItem(name: homeAndKitchen, icon: IconsaxPlusLinear.coffee),
  ];

  // Backward-compatible alias
  static List<CategoryItem> get items => defaultItems;

  // Returns the appropriate icon for a given category name
  static IconData iconFor(String categoryName) {
    final lower = categoryName.trim().toLowerCase();
    if (lower == 'all') return IconsaxPlusLinear.category;
    if (lower.contains('electron') ||
        lower.contains('phone') ||
        lower.contains('headphone') ||
        lower.contains('audio')) {
      return IconsaxPlusLinear.headphone;
    }
    if (lower.contains('foot') ||
        lower.contains('shoe') ||
        lower.contains('sneaker')) {
      return IconsaxPlusLinear.tag;
    }
    if (lower.contains('access') ||
        lower.contains('watch') ||
        lower.contains('jewel')) {
      return IconsaxPlusLinear.watch;
    }
    if (lower.contains('game') || lower.contains('gaming')) {
      return IconsaxPlusLinear.game;
    }
    if (lower.contains('home') ||
        lower.contains('kitchen') ||
        lower.contains('cook')) {
      return IconsaxPlusLinear.coffee;
    }
    if (lower.contains('cloth') ||
        lower.contains('fashion') ||
        lower.contains('wear') ||
        lower.contains('shirt') ||
        lower.contains('pant')) {
      return IconsaxPlusLinear.scissor;
    }
    if (lower.contains('beauty') ||
        lower.contains('care') ||
        lower.contains('health')) {
      return IconsaxPlusLinear.heart;
    }
    if (lower.contains('book') || lower.contains('stationery')) {
      return IconsaxPlusLinear.book;
    }
    if (lower.contains('sport') || lower.contains('fitness')) {
      return IconsaxPlusLinear.activity;
    }
    return IconsaxPlusLinear.box;
  }

  // Builds a list of CategoryItems dynamically from a list of category names
  static List<CategoryItem> itemsFromNames(Iterable<String> categoryNames) {
    return categoryNames
        .map((name) => CategoryItem(name: name, icon: iconFor(name)))
        .toList();
  }

  // Derives unique category names dynamically from a list of products
  static List<String> categoryNamesFromProducts(
    Iterable<ProductModel> products, {
    bool includeAll = true,
  }) {
    final dynamicCategories = products
        .map((p) => p.category.trim())
        .where((c) => c.isNotEmpty)
        .toSet();

    return [
      if (includeAll) all,
      ...dynamicCategories,
      ...defaultNames.where(
        (name) => name != all && !dynamicCategories.contains(name),
      ),
    ];
  }

  // Derives CategoryItem list with icons dynamically from a list of products
  static List<CategoryItem> itemsFromProducts(
    Iterable<ProductModel> products, {
    bool includeAll = true,
  }) {
    return itemsFromNames(
      categoryNamesFromProducts(products, includeAll: includeAll),
    );
  }
}
