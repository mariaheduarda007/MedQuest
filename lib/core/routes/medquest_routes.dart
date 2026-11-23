import 'package:go_router/go_router.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/auth/presentation/views/home_view.dart';
import 'package:medquest/auth/presentation/views/splash_view.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/group/presentation/views/group_view.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/presentation/views/modelquest_view.dart';
import 'package:medquest/modelquest/presentation/views/modelquests_view.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/patient/presentation/views/patient_view.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/views/research_view.dart';
import 'package:medquest/research/presentation/views/researches_page.dart';
import 'package:medquest/auth/presentation/views/signin_view.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/userContext/user/presentation/views/profile_view.dart';
import 'package:medquest/answeredquest/presentation/views/answeredquest_inactive_view.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

class MedQuestRouteNames {
  static const home = 'home';
  static const profile = 'profile';
  static const researches = 'researches';
  static const research = 'research';
  static const group = 'group';
  static const patient = 'patient';
  static const quests = 'quests';
  static const modelquest = 'modelquest';
  static const answeredquestInactive = 'answeredquest_inactive';
}

class MedQuestPaths {
  static const home = '/home';
  static const profile = '/profile';
  static const researches = '/researches';
  static const research = '/research';
  static const group = '/group';
  static const patient = '/patient';
  static const quests = '/quests';
  static const modelquest = '/modelquest';
  static const answeredquestInactive = '/answeredquest_inactive';
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
    builder: (context, state) => const ResearchesView(),
  ),

  GoRoute(
    path: MedQuestPaths.research,
    name: MedQuestRouteNames.research,
    builder: (context, state) {
      final extra = state.extra as Research;
      return ResearchView(research: extra);
    },
  ),
  GoRoute(
    path: MedQuestPaths.group,
    name: MedQuestRouteNames.group,
    builder: (context, state) {
      final extra = state.extra as ({Research research, Group group});
      return GroupView(research: extra.research, group: extra.group);
    },
  ),
  GoRoute(
    path: MedQuestPaths.patient,
    name: MedQuestRouteNames.patient,
    builder: (context, state) {
      final extra =
          state.extra as ({Research research, Group group, Patient patient});
      return PatientView(
        research: extra.research,
        group: extra.group,
        patient: extra.patient,
      );
    },
  ),
  GoRoute(
    path: MedQuestPaths.quests,
    name: MedQuestRouteNames.quests,
    builder: (context, state) {
       final authController = injector.get<AuthViewModel>();
      final authSession = authController.session.session.value;

      if (authSession == null) {
        return const LoginPage();
      }
      return ModelQuestsView(session: authSession);
     },
  ),
   GoRoute(
    path: MedQuestPaths.modelquest,
    name: MedQuestRouteNames.modelquest,
    builder: (context, state) {
      final extra = state.extra as ModelQuest;
      return ModelQuestView(modelquest: extra);
    },
  ),
  GoRoute(
    path: MedQuestPaths.profile,
    name: MedQuestRouteNames.profile,
    builder: (context, state) => const ProfileView(),
  ),
  GoRoute(
    path: MedQuestPaths.answeredquestInactive,
    name: MedQuestRouteNames.answeredquestInactive,
    builder: (context, state) {
      final extra = state.extra as ({
        AnsweredQuest answeredQuest,
        ModelQuest modelquest,
        String researchId,
        String groupId,
        String patientId,
      });

      return AnsweredQuestInactiveView(
        answeredQuest: extra.answeredQuest,
        modelquest: extra.modelquest,
        researchId: extra.researchId,
        groupId: extra.groupId,
        patientId: extra.patientId,
      );
    },
  ),
];
