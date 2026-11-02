import 'package:flutter/material.dart';

// Screen Types
enum ResponsiveScreenType { mobile, tablet, desktop }

// Responsive layout widget
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : builder = null;

  const ResponsiveLayout.builder({
    super.key,
    required Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      ResponsiveScreenType screenType,
    )
    this.builder,
  }) : mobile = const SizedBox.shrink(),
       tablet = null,
       desktop = const SizedBox.shrink();

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    ResponsiveScreenType screenType,
  )?
  builder;

  // Standard breakpoint constants
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1100.0;

  // Media query helper queries
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static ResponsiveScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) return ResponsiveScreenType.desktop;
    if (width >= mobileBreakpoint) return ResponsiveScreenType.tablet;
    return ResponsiveScreenType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = _resolveScreenType(constraints.maxWidth);

        if (builder != null) {
          return builder!(context, constraints, screenType);
        }

        switch (screenType) {
          case ResponsiveScreenType.desktop:
            return desktop;
          case ResponsiveScreenType.tablet:
            return tablet ?? desktop;
          case ResponsiveScreenType.mobile:
            return mobile;
        }
      },
    );
  }

  static ResponsiveScreenType _resolveScreenType(double width) {
    if (width >= tabletBreakpoint) {
      return ResponsiveScreenType.desktop;
    } else if (width >= mobileBreakpoint) {
      return ResponsiveScreenType.tablet;
    } else {
      return ResponsiveScreenType.mobile;
    }
  }
}
