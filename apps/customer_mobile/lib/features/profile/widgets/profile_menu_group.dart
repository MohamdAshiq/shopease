import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

// Profile Menu Group Card
class ProfileMenuGroup extends StatelessWidget {
  const ProfileMenuGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.xs,
              bottom: AppSizes.xs + 2,
            ),
            child: Text(
              title!.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.4)),
          ),
          child: Material(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: AppSizes.inputHeight,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
