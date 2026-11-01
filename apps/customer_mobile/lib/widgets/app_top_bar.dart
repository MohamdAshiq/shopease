import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../app/routing/route_constants.dart';

// Custom Appbar
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.titleStyle,
    this.backgroundColor,
  });

  final String title;
  final bool centerTitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style:
            titleStyle ??
            AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: showBack
          ? IconButton(
              icon: const Icon(IconsaxPlusLinear.arrow_left),
              onPressed:
                  onBack ??
                  () => Navigator.of(context).canPop()
                      ? context.pop()
                      : context.go(RoutePaths.home),
            )
          : null,
      actions: actions,
    );
  }
}
