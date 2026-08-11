import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_bottom_navigation.dart';
import 'persistent_banner_ad.dart';

/// Tüm sekme ekranlarını saran ortak Scaffold iskelet.
class AppScaffold extends StatelessWidget {
  final Widget child;
  final StatefulNavigationShell? navigationShell;

  const AppScaffold({
    super.key,
    required this.child,
    this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: child,
      bottomNavigationBar: Container(
        color: theme.colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomBottomNavigation(
                navigationShell: navigationShell,
              ),
              const PersistentBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
