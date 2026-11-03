import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/wishlist_cubit.dart';

// Helper for triggering wishlist actions
abstract final class WishlistActionHelper {
  static bool toggleWishlist(
    BuildContext context, {
    required ProductModel product,
  }) {
    HapticFeedback.lightImpact();
    final added = context.read<WishlistCubit>().toggleWishlist(product);
    AppSnackBar.show(
      context,
      message: added
          ? 'Added "${product.title}" to wishlist'
          : 'Removed "${product.title}" from wishlist',
      duration: const Duration(milliseconds: 1500),
    );
    return added;
  }
}
