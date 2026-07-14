import 'package:medquest/core/routes/auth_routes.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
// import 'package:medquest/under_construction_view.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppRouter {
  AppRouter._();

 static final GoRouter router = GoRouter(
  initialLocation: AuthPaths.splash,
  // Esta lógica roda sempre que o usuário tenta mudar de rota
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == AuthPaths.login || state.matchedLocation == AuthPaths.register;
    
    // Se não estiver logado e não estiver na tela de login/registro, vai pro login
    if (user == null && !isLoggingIn) return AuthPaths.login;
    
    // Se já estiver logado e tentar ir pro login, manda pra Home
    if (user != null && isLoggingIn) return '/home';
    
    return null; // Nenhuma mudança necessária
  },
  routes: <RouteBase>[
    ...authRoutes,
    ...appRoutes, // Aqui ficam suas rotas internas (Home, Patients, etc)
  ],
);
}