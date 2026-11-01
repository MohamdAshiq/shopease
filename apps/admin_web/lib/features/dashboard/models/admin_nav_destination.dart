import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/admin_route_constants.dart';

// Navigation destinations for the admin portal
enum AdminNavDestination {
  dashboard(
    label: 'Dashboard',
    routePath: AdminRoutePaths.dashboard,
    routeName: AdminRouteNames.dashboard,
    icon: IconsaxPlusLinear.element_3,
    selectedIcon: IconsaxPlusBold.element_3,
  ),
  products(
    label: 'Products',
    routePath: AdminRoutePaths.products,
    routeName: AdminRouteNames.products,
    icon: IconsaxPlusLinear.box,
    selectedIcon: IconsaxPlusBold.box,
  ),
  orders(
    label: 'Orders',
    routePath: AdminRoutePaths.orders,
    routeName: AdminRouteNames.orders,
    icon: IconsaxPlusLinear.receipt_text,
    selectedIcon: IconsaxPlusBold.receipt_text,
  ),
  customers(
    label: 'Customers',
    routePath: AdminRoutePaths.customers,
    routeName: AdminRouteNames.customers,
    icon: IconsaxPlusLinear.profile_2user,
    selectedIcon: IconsaxPlusBold.profile_2user,
  ),
  settings(
    label: 'Settings',
    routePath: AdminRoutePaths.settings,
    routeName: AdminRouteNames.settings,
    icon: IconsaxPlusLinear.setting_2,
    selectedIcon: IconsaxPlusBold.setting_2,
  );

  const AdminNavDestination({
    required this.label,
    required this.routePath,
    required this.routeName,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String routePath;
  final String routeName;
  final IconData icon;
  final IconData selectedIcon;
}
