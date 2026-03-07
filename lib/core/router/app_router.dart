import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/services/presentation/pages/service_detail_page.dart';
import '../../features/services/presentation/pages/services_page.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: <RouteBase>[
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
