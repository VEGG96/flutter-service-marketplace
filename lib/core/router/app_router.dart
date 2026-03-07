import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/services/presentation/pages/provider_dashboard_page.dart';
import '../../features/services/presentation/pages/service_detail_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import 'go_router_refresh_stream.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = authBloc.state;

      final bool isSplash = state.matchedLocation == AppRoutes.splash;
      final bool isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final bool isGoingToRegister =
          state.matchedLocation == AppRoutes.register;
      final bool isAuthRoute = isGoingToLogin || isGoingToRegister;
      final bool isGoingToProviderDashboard =
          state.matchedLocation == AppRoutes.providerDashboard;

      if (authState is AuthInitial || authState is AuthLoading) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (authState is Unauthenticated) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (authState is AuthError) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (authState is Authenticated && isAuthRoute) {
        return authState.user.role == UserRole.provider
            ? AppRoutes.providerDashboard
            : AppRoutes.services;
      }

      if (authState is Authenticated && isSplash) {
        return authState.user.role == UserRole.provider
            ? AppRoutes.providerDashboard
            : AppRoutes.services;
      }

      if (authState is Authenticated &&
          isGoingToProviderDashboard &&
          authState.user.role != UserRole.provider) {
        return AppRoutes.services;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: 'services',
        builder: (BuildContext context, GoRouterState state) =>
            const ServicesPage(),
      ),
      GoRoute(
        path: AppRoutes.providerDashboard,
        name: 'provider-dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.serviceDetail,
        name: 'service-detail',
        builder: (BuildContext context, GoRouterState state) {
          final String serviceId = state.uri.queryParameters['id'] ?? '';
          return ServiceDetailPage(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingPage(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (BuildContext context, GoRouterState state) =>
            const ChatPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfilePage(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Ruta no encontrada: ${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}
