import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import 'app/routing/admin_router.dart';
import 'features/auth/cubits/admin_auth_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AdminAuthCubit())],
      child: MaterialApp.router(
        title: 'ShopEase Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: adminRouter,
      ),
    );
  }
}
