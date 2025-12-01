import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/auth/presentation/login_screen.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';
import 'package:handy_connect/features/customer/presentation/booking_form_screen.dart';
import 'package:handy_connect/features/customer/presentation/customer_profile_screen.dart';
import 'package:handy_connect/features/customer/presentation/handyman_list_screen.dart';
import 'package:handy_connect/features/customer/presentation/handyman_profile_screen.dart';
import 'package:handy_connect/features/customer/presentation/home_screen.dart';
import 'package:handy_connect/features/customer/presentation/my_requests_screen.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/presentation/requests_list_screen.dart';
import 'package:handy_connect/features/handyman/presentation/profile_setup_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegistrationScreen(),
      ),
      GoRoute(
        path: '/customer_home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/handyman_home',
        builder: (BuildContext context, GoRouterState state) =>
            const RequestsListScreen(),
      ),
      GoRoute(
        path: '/handyman_list/:category',
        builder: (BuildContext context, GoRouterState state) =>
            HandymanListScreen(category: state.pathParameters['category']!),
      ),
      GoRoute(
        path: '/handyman_profile',
        builder: (BuildContext context, GoRouterState state) =>
            HandymanProfileScreen(handyman: state.extra as HandymanUser),
      ),
      GoRoute(
        path: '/booking',
        builder: (BuildContext context, GoRouterState state) =>
            BookingFormScreen(handyman: state.extra as HandymanUser),
      ),
      GoRoute(
        path: '/my_requests',
        builder: (BuildContext context, GoRouterState state) =>
            const MyRequestsScreen(),
      ),
      GoRoute(
        path: '/customer_profile',
        builder: (BuildContext context, GoRouterState state) =>
            const CustomerProfileScreen(),
      ),
      GoRoute(
        path: '/handyman_profile_setup',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileSetupScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthenticated =
          authState is Authenticated || authState is AuthenticatedWithUserType;
      final isAuthScreen =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuthenticated && !isAuthScreen) {
        return '/login';
      }

      if (isAuthenticated && isAuthScreen) {
        if (authState is AuthenticatedWithUserType) {
          return authState.userType == 'handyman'
              ? '/handyman_home'
              : '/customer_home';
        } else {
          // If user type is not yet known, stay on a loading screen or go to a default home
          // For now, we'll dispatch an event to get the user type
          if (authState is Authenticated) {
            authBloc.add(GetUserTypeRequested(authState.user.uid));
          }
          return null; // Stay on the current screen (which should be a loading screen)
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
