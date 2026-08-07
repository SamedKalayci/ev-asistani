import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../features/inventory/screens/inventory_screen.dart';
import '../../router/app_router.dart';

/// 5 sekmeli alt navigasyon (CustomBottomNavigation) bileşeni.
/// StatefulNavigationShell desteği ve initialLocation: true ile sekme sıfırlama mekanizması içerir.
class CustomBottomNavigation extends ConsumerWidget {
  /// GoRouter StatefulNavigationShell referansı
  final StatefulNavigationShell? navigationShell;

  /// Seçili sekme indeksi (null ise rotadan veya navigationShell'den otomatik belirlenir)
  final int? currentIndex;

  /// Sekme değiştiğinde çalışacak callback
  final ValueChanged<int>? onDestinationSelected;

  /// Arka plan rengi özel tanımı
  final Color? backgroundColor;

  /// Aktif sekme vurgu rengi özel tanımı
  final Color? indicatorColor;

  /// Üst kenarlık ve gölge gösterilip gösterilmeyeceği
  final bool showShadow;

  const CustomBottomNavigation({
    super.key,
    this.navigationShell,
    this.currentIndex,
    this.onDestinationSelected,
    this.backgroundColor,
    this.indicatorColor,
    this.showShadow = true,
  });

  int _getEffectiveIndex(BuildContext context) {
    if (navigationShell != null) {
      return navigationShell!.currentIndex;
    }

    if (currentIndex != null) return currentIndex!;

    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.home) {
      return 0;
    } else if (location.startsWith(AppRoutes.inventory) ||
        location.startsWith(AppRoutes.expiration) ||
        location.startsWith(AppRoutes.warranty)) {
      return 1;
    } else if (location.startsWith(AppRoutes.shopping)) {
      return 2;
    } else if (location.startsWith(AppRoutes.finance)) {
      return 3;
    } else if (location.startsWith(AppRoutes.profile)) {
      return 4;
    }
    return 0;
  }

  void _handleDestinationSelected(BuildContext context, WidgetRef ref, int index) {
    // 1. Root navigator üzerindeki tüm imperative push sayfalarını (örn. VaultDetails, Formlar) kapat
    try {
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) {
        rootNav.popUntil((route) => route.isFirst);
      }
    } catch (_) {}

    // Envanter sekmesine tıklanmışsa üst sekmeleri "Son Kullanma" (0) ekranına sıfırla
    if (index == 1) {
      ref.read(inventoryTabProvider.notifier).state = 0;
    }

    // 2. StatefulNavigationShell varsa goBranch(index, initialLocation: true) ile sekme köküne sıfırla
    if (navigationShell != null) {
      navigationShell!.goBranch(
        index,
        initialLocation: true, // Sekme geçmişini KÖK EKRANINA sıfırlar
      );
      return;
    }

    if (onDestinationSelected != null) {
      onDestinationSelected!(index);
      return;
    }

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.inventory);
        break;
      case 2:
        context.go(AppRoutes.shopping);
        break;
      case 3:
        context.go(AppRoutes.finance);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIndex = _getEffectiveIndex(context);

    final effectiveBgColor =
        backgroundColor ?? colorScheme.surface.withValues(alpha: 0.98);

    final effectiveIndicatorColor =
        indicatorColor ?? const Color(0xFFDCFCE7);
    const activeColor = AppColors.primary;
    final inactiveColor = colorScheme.onSurfaceVariant;

    Widget navBar = NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: effectiveIndicatorColor,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: inactiveColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: activeColor, size: 24);
          }
          return IconThemeData(color: inactiveColor, size: 24);
        }),
      ),
      child: NavigationBar(
        selectedIndex: effectiveIndex,
        onDestinationSelected: (index) => _handleDestinationSelected(context, ref, index),
        backgroundColor: effectiveBgColor,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          // 1. 🏠 Ana Sayfa
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          // 2. 📦 Envanter
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Envanter',
          ),
          // 3. 🛒 Alışveriş
          const NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Alışveriş',
          ),
          // 4. 💳 Finans (👑 PRO Rozetli)
          NavigationDestination(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.account_balance_wallet_outlined),
                Positioned(
                  top: -5,
                  right: -7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: AppRadius.borderFull,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Text(
                      '👑',
                      style: TextStyle(fontSize: 8, height: 1.0),
                    ),
                  ),
                ),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.account_balance_wallet_rounded),
                Positioned(
                  top: -5,
                  right: -7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: AppRadius.borderFull,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Text(
                      '👑',
                      style: TextStyle(fontSize: 8, height: 1.0),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Finans',
          ),
          // 5. 👤 Profil
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );

    if (showShadow) {
      return Container(
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: AppRadius.borderTopLg,
          boxShadow: AppShadows.navigationBar,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.borderTopLg,
          child: navBar,
        ),
      );
    }

    return navBar;
  }
}
