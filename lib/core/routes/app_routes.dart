import 'package:medquest/core/routes/auth_routes.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
// import 'package:medquest/under_construction_view.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/core/di/injector.dart';


class AppRouter {
  AppRouter._();

static final GoRouter router = GoRouter(
  initialLocation: AuthPaths.splash,
  refreshListenable: injector.get<AuthViewModel>(), 
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == AuthPaths.login || state.matchedLocation == AuthPaths.register;
    final isSplash = state.matchedLocation == AuthPaths.splash;
    
    if (user == null && !isLoggingIn && !isSplash) return AuthPaths.login;
    if (user != null && isLoggingIn) return '/home';
    
    return null;
  },
  routes: <RouteBase>[
    ...authRoutes,
    ...appRoutes,
  ],
);
}