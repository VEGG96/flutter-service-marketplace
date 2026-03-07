import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/services/presentation/service_detail_screen.dart';
import '../../features/services/presentation/services_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: 'services',
        builder: (BuildContext context, GoRouterState state) =>
            const ServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.serviceDetail,
        name: 'service-detail',
        builder: (BuildContext context, GoRouterState state) {
          final String serviceId = state.uri.queryParameters['id'] ?? '';
          return ServiceDetailScreen(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (BuildContext context, GoRouterState state) =>
            const ChatScreen(),
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
