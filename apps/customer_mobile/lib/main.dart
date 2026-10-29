import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'features/home/views/home_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeNavScreen(),
    );
  }
}
