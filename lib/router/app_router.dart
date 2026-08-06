import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/user_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/expiration/screens/expiration_form_screen.dart';
import '../features/finance/screens/finance_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/inventory/screens/inventory_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/recipes/screens/recipe_form_screen.dart';
import '../features/recipes/screens/recipes_screen.dart';
import '../features/shopping/screens/shopping_screen.dart';
import '../features/warranty/screens/warranty_form_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../shared/widgets/app_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Splash ekranının animasyon süresini doldurup doldurmadığını izler.
final splashFinishedProvider = StateProvider<bool>((ref) => false);

/// Riverpod state değişikliklerini GoRouter'a bildiren listenable sınıfı.
class RiverpodRouterNotifier extends ChangeNotifier {
  RiverpodRouterNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(authStateProvider, (_, _) {
      notifyListeners();
    });
    _ref.listen<bool>(splashFinishedProvider, (_, _) {
      notifyListeners();
    });
  }
  final Ref _ref;
}

final routerNotifierProvider = Provider<RiverpodRouterNotifier>((ref) {
  return RiverpodRouterNotifier(ref);
});

/// GoRouter yapılandırması — StatefulShellRoute & Auth Guard entegreli.
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isSplashFinished = ref.read(splashFinishedProvider);

      // Splash süresi dolmadıysa veya Auth State henüz yükleniyorsa Splash'te kal
      if (!isSplashFinished || authState.isLoading) {
        if (state.matchedLocation != AppRoutes.splash) {
          return AppRoutes.splash;
        }
        return null; // Zaten splash ekranında
      }

      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isSplashRoute = state.matchedLocation == AppRoutes.splash;

      // Splash bitti ve giriş yapılmamışsa ve auth rotasında değilse -> /giris
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Splash bitti ve giriş yapılmışsa, auth veya splash rotasındaysa -> /
      if (isLoggedIn && (isAuthRoute || isSplashRoute)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── StatefulShellRoute: Her sekmenin kendi bağımsız geçmişini yönetir ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(
            navigationShell: navigationShell,
            child: navigationShell,
          );
        },
        branches: [
          // Branch 0: Ana Sayfa
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          // Branch 1: Envanter (Top 3 Tab: Son Kullanma | Garantiler | Kasa)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.inventory,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: InventoryScreen(initialTabIndex: 0),
                ),
              ),
              GoRoute(
                path: AppRoutes.expiration,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: InventoryScreen(initialTabIndex: 0),
                ),
                routes: [
                  GoRoute(
                    path: 'ekle',
                    builder: (context, state) => const ExpirationFormScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: AppRoutes.warranty,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: InventoryScreen(initialTabIndex: 1),
                ),
                routes: [
                  GoRoute(
                    path: 'ekle',
                    builder: (context, state) => const WarrantyFormScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Alışveriş
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shopping,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ShoppingScreen(),
                ),
              ),
            ],
          ),
          // Branch 3: Finans
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.finance,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FinanceScreen(),
                ),
              ),
            ],
          ),
          // Branch 4: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
          // Ekstra: Yemek Tarifleri
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recipes,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RecipesScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'ekle',
                    builder: (context, state) => const RecipeFormScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Uygulama rota sabitleri.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/giris';
  static const String register = '/kayit';
  static const String home = '/';
  static const String inventory = '/envanter';
  static const String expiration = '/son-kullanma';
  static const String expirationAdd = '/son-kullanma/ekle';
  static const String warranty = '/garanti';
  static const String warrantyAdd = '/garanti/ekle';
  static const String shopping = '/alisveris';
  static const String finance = '/finans';
  static const String recipes = '/tarifler';
  static const String recipesAdd = '/tarifler/ekle';
  static const String profile = '/profil';
}
