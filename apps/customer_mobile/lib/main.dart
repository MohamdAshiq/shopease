import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import 'app/routing/app_router.dart';
import 'features/auth/cubits/auth_cubit.dart';
import 'features/auth/cubits/auth_state.dart';
import 'features/cart/cubits/cart_cubit.dart';
import 'features/orders/cubits/order_cubit.dart';
import 'features/profile/cubits/profile_cubit.dart';
import 'features/wishlist/cubits/wishlist_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase backend
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Error Builder
  ErrorWidget.builder = (details) => AppErrorFallback(details: details);

  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(
          create: (context) => ProfileCubit(
            authRepository: authRepository ?? FirebaseAuthRepository(),
          ),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous.user != current.user,
        listener: (context, state) {
          context.read<ProfileCubit>().setUser(state.user);
          context.read<OrderCubit>().setCustomer(state.user);
          context.read<WishlistCubit>().setCustomer(state.user);
          context.read<CartCubit>().setCustomer(state.user);
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
