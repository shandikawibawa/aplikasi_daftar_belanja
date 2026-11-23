import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/main_scaffold_with_nav_bar.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/shopping_list/presentation/create_shopping_list_screen.dart';
import 'features/shopping_list/presentation/shopping_detail_screen.dart';
import 'features/shopping_list/presentation/shopping_lists_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GoRouter createAppRouter(AuthRepository? authRepository) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      if (authRepository == null) return null;

      final location = state.uri.path;
      final onboardingComplete = authRepository.onboardingCompleted;
      final loggedIn = authRepository.currentUser != null;

      if (!onboardingComplete && location != '/onboarding') {
        return '/onboarding';
      }
      if (onboardingComplete && location == '/onboarding') {
        return loggedIn ? '/' : '/login';
      }
      if (loggedIn && (location == '/login' || location == '/register')) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthScreen(isRegister: false),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthScreen(isRegister: true),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Beranda
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Daftar Belanja
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/daftar',
                builder: (context, state) => const ShoppingListsScreen(),
              ),
            ],
          ),
          // Tab 2: Riwayat Belanja
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/riwayat',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          // Tab 3: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profil',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Halaman Detail Belanja / Shopping Mode
      GoRoute(
        path: '/buat-daftar',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateShoppingListScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'active_1';
          return ShoppingDetailScreen(listId: id);
        },
      ),
    ],
  );
}
