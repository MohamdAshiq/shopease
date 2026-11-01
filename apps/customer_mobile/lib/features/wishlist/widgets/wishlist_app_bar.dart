import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/route_constants.dart';
import '../../../widgets/app_top_bar.dart';
import '../../cart/cubits/cart_cubit.dart';
import '../../cart/cubits/cart_state.dart';
import '../cubits/wishlist_cubit.dart';
import '../cubits/wishlist_state.dart';

// AppBar for Wishlist Screen
class WishlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WishlistAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      buildWhen: (previous, current) => previous.itemCount != current.itemCount,
      builder: (context, wishlistState) {
        final itemCount = wishlistState.itemCount;

        return AppTopBar(
          title: itemCount > 0 ? 'Wishlist ($itemCount)' : 'Wishlist',
          showBack: false,
          centerTitle: false,
          actions: [
            // Cart icon with count badge
            BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) =>
                  previous.totalItemCount != current.totalItemCount,
              builder: (context, cartState) {
                final count = cartState.totalItemCount;
                return IconButton(
                  icon: Badge(
                    isLabelVisible: count > 0,
                    label: Text('$count'),
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      IconsaxPlusLinear.shopping_bag,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  tooltip: 'Shopping Cart',
                  onPressed: () => context.pushNamed(RouteNames.cart),
                );
              },
            ),

            const SizedBox(width: AppSizes.xs),
          ],
        );
      },
    );
  }
}
