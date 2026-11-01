import 'package:flutter/material.dart';
import 'package:shopease_core/shopease_core.dart';

import '../../../app/routing/admin_route_constants.dart';
import '../../auth/cubits/admin_auth_cubit.dart';
import '../../auth/cubits/admin_auth_state.dart';
import '../models/admin_nav_destination.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_sidebar.dart';

// Responsive Admin Shell
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.child});

  final Widget child;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _closeDrawerIfOpen() {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  AdminNavDestination _getDestinationFromPath(String path) {
    for (final dest in AdminNavDestination.values) {
      if (path.startsWith(dest.routePath)) {
        return dest;
      }
    }
    return AdminNavDestination.dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (!state.isAuthenticated) {
          context.go(AdminRoutePaths.login);
        }
      },
      builder: (context, state) {
        final admin = state.user ?? mockAdmin;
        final adminName = admin.displayName;
        final currentPath = GoRouterState.of(context).uri.path;
        final selectedDestination = _getDestinationFromPath(currentPath);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.scaffoldBackground,
          drawer: Drawer(
            child: AdminSidebar(
              selectedDestination: selectedDestination,
              onDestinationSelected: (dest) {
                _closeDrawerIfOpen();
                context.go(dest.routePath);
              },
              adminName: adminName,
              adminEmail: admin.email,
              onLogout: () {
                _closeDrawerIfOpen();
                context.read<AdminAuthCubit>().logout();
              },
            ),
          ),
          body: ResponsiveLayout(
            desktop: _buildDesktopLayout(
              selectedDestination,
              adminName,
              admin.email,
            ),
            tablet: _buildTabletLayout(
              selectedDestination,
              adminName,
              admin.email,
            ),
            mobile: _buildMainContent(selectedDestination, isMobile: true),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    AdminNavDestination selectedDestination,
    String adminName,
    String adminEmail,
  ) {
    return Row(
      children: [
        AdminSidebar(
          selectedDestination: selectedDestination,
          onDestinationSelected: (dest) => context.go(dest.routePath),
          adminName: adminName,
          adminEmail: adminEmail,
          onLogout: () => context.read<AdminAuthCubit>().logout(),
        ),
        Expanded(child: _buildMainContent(selectedDestination)),
      ],
    );
  }

  Widget _buildTabletLayout(
    AdminNavDestination selectedDestination,
    String adminName,
    String adminEmail,
  ) {
    return Row(
      children: [
        AdminSidebar(
          isCompact: true,
          selectedDestination: selectedDestination,
          onDestinationSelected: (dest) => context.go(dest.routePath),
          adminName: adminName,
          adminEmail: adminEmail,
          onLogout: () => context.read<AdminAuthCubit>().logout(),
        ),
        Expanded(child: _buildMainContent(selectedDestination)),
      ],
    );
  }

  Widget _buildMainContent(
    AdminNavDestination selectedDestination, {
    bool isMobile = false,
  }) {
    return Column(
      children: [
        AdminHeader(
          title: selectedDestination.label,
          showMenuButton: isMobile,
          onMenuPressed: isMobile
              ? () => _scaffoldKey.currentState?.openDrawer()
              : null,
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
