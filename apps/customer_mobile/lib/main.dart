import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

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
      home: const CustomerHomeScreen(),
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShopEase'), centerTitle: true),
      body: const Center(
        child: Text(
          'Welcome to ShopEase',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
