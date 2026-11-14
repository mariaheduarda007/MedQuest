import 'package:go_router/go_router.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/auth/presentation/pages/home_page.dart';
import 'package:medquest/modelquest/presentation/pages/modelquests_page.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/pages/research_page.dart';
import 'package:medquest/research/presentation/pages/researches_page.dart';
import 'package:medquest/auth/presentation/pages/signin_page.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/userContext/user/presentation/views/profile_view.dart';

class MedQuestRouteNames {
  static const home = 'home';
  static const profile = 'profile';
  static const researches = 'researches';
  static const research = 'research';
  static const quests = 'quests';
}

class MedQuestPaths {
  static const home = '/home';
  static const profile = '/profile';
  static const researches = '/researches';
  static const research = '/research';
  static const quests = '/quests';
}

final List<RouteBase> appRoutes = [
  GoRoute(
    path: MedQuestPaths.home,
    name: MedQuestRouteNames.home,
    builder: (context, state) {
      final authController = injector.get<AuthViewModel>();

      // Acessamos o signal 'session' dentro do objeto 'session' do Controller
      // e pegamos o '.value' para ter o objeto AuthSession
      final authSession = authController.session.session.value;

      // Segurança: se não houver sessão, redireciona para o login
      if (authSession == null) {
        return const LoginPage();
      }

      return MyHomePage(title: 'MedQuest Home', session: authSession);
    },
  ),
  GoRoute(
    path: MedQuestPaths.researches,
    name: MedQuestRouteNames.researches,
    builder: (context, state) => const ResearchesPage(),
  ),
  GoRoute(
    path: MedQuestPaths.research,
    name: MedQuestRouteNames.research,
    builder: (context, state) {
      final extra = state.extra as Research;
      return ResearchPage(research: extra);
    },
  ),
  GoRoute(
    path: MedQuestPaths.quests,
    name: MedQuestRouteNames.quests,
    builder: (context, state) => const ModelQuestsPage(),
  ),
  GoRoute(
    path: MedQuestPaths.profile,
    name: MedQuestRouteNames.profile,
    builder: (context, state) => const ProfileView(),
  ),
];
