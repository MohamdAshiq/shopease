import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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

  // List of category names
  static const List<String> names = [
    all,
    electronics,
    footwear,
    accessories,
    gaming,
    homeAndKitchen,
  ];

  static const List<CategoryItem> items = [
    CategoryItem(name: all, icon: IconsaxPlusLinear.category),
    CategoryItem(name: electronics, icon: IconsaxPlusLinear.headphone),
    CategoryItem(name: footwear, icon: IconsaxPlusLinear.tag),
    CategoryItem(name: accessories, icon: IconsaxPlusLinear.watch),
    CategoryItem(name: gaming, icon: IconsaxPlusLinear.game),
    CategoryItem(name: homeAndKitchen, icon: IconsaxPlusLinear.coffee),
  ];
}
