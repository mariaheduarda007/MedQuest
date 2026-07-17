import 'package:go_router/go_router.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/auth/presentation/pages/home_page.dart';
import 'package:medquest/auth/presentation/pages/signin_page.dart'; 
import 'package:medquest/core/di/dependency_injection.dart';
import 'package:medquest/userContext/user/presentation/views/profile_view.dart';

final List<RouteBase> appRoutes = [
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) {
     final authController = injector.get<AuthViewModel>();
      
      // Acessamos o signal 'session' dentro do objeto 'session' do Controller
      // e pegamos o '.value' para ter o objeto AuthSession
      final authSession = authController.session.session.value;

      // Segurança: se não houver sessão, redireciona para o login
      if (authSession == null) {
        return const LoginPage(); 
      }

      return MyHomePage(
        title: 'MedQuest Home',
        session: authSession, 
      );
    },
  ),
  GoRoute(
    path: '/profile',
    name: 'profile',
    builder: (context, state) => const ProfileView(),
  ),
];