import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keycloack_integrations/src/data/repositories/autentication_repository.dart';
import 'package:keycloack_integrations/src/presentation/loading/loading_page.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';
import 'package:keycloack_integrations/src/presentation/login/screens/login_screen.dart';
import 'package:keycloack_integrations/src/presentation/home/main_screen.dart';
import 'package:keycloack_integrations/src/router/di.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Control para tiempo mínimo de loading
DateTime? _loadingStartTime;
const _minLoadingDuration = Duration(milliseconds: 1800);

GoRouter createRouter() {
  _loadingStartTime = DateTime.now();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/main',
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (context, state) async {
      final authState = getIt<AuthBloc>().state;
      final currentPath = state.matchedLocation;

      // Si estamos en loading, verificar tiempo mínimo
      if (currentPath == '/loading' && authState is! UnknownState) {
        final elapsed = DateTime.now().difference(_loadingStartTime!);
        if (elapsed < _minLoadingDuration) {
          // Esperar el tiempo restante antes de redirigir
          Future.delayed(_minLoadingDuration - elapsed, () {
            _rootNavigatorKey.currentContext?.go(
              authState is Authenticated ? '/main' : '/login',
            );
          });
          return null; // Mantener en loading mientras esperamos
        }
      }

      if (authState is UnknownState) {
        return currentPath == '/loading' ? null : '/loading';
      }

      final isAuthenticated = authState is Authenticated;

      if (isAuthenticated) {
        if (currentPath == '/login' || currentPath == '/loading') {
          return '/main';
        }
        return null;
      }

      // Usuario no autenticado (Unauthenticated)
      if (currentPath != '/login') {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          authenticationRepository: getIt<AuthenticationRepository>(),
        ),
      ),
      GoRoute(path: '/loading', builder: (context, state) => LoadingPage()),

      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
    ],
  );
}
