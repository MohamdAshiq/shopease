import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import 'app/routing/app_router.dart';
import 'features/auth/cubits/auth_cubit.dart';
import 'features/auth/cubits/auth_state.dart';
import 'features/cart/cubits/cart_cubit.dart';
import 'features/orders/cubits/order_cubit.dart';
import 'features/profile/cubits/profile_cubit.dart';
import 'features/wishlist/cubits/wishlist_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.user != current.user,
        listener: (context, state) {
          context.read<ProfileCubit>().setUser(state.user);
        },
        child: MaterialApp.router(
          title: 'ShopEase',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
