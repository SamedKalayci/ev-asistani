import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_bottom_navigation.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavigation(
        navigationShell: navigationShell,
      ),
    );
  }
}
