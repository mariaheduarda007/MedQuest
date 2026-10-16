import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/data/services/remote/i_userRole_remote_service.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/routes/auth_routes.dart';
import 'package:medquest/core/theme/theme.dart';
import '../../domain/models/auth_entities.dart';
import '../controllers/auth_session_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/research_card.dart';
import 'package:medquest/research/presentation/widgets/app_search_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.session});

  final String title;
  final AuthSession session;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  late final AuthViewModel authController;
  bool canCreateResearch = false;
  bool isLoadingPermissions = true;

  @override
  void initState() {
    authController = injector.get<AuthViewModel>();
    super.initState();
    _loadUserPermissions();
  }

  Future<void> _loadUserPermissions() async {
    try {
      final userRoleService = injector
          .get<IUserRoleRemoteService>(); 
      final permissionService = injector.get<PermissionCacheService>();

      final result = await userRoleService.getUserRolesByUserId(
        widget.session.user.uid,
      );

     if (result.isSuccess) { 
        final roles = result.successValueOrNull ?? [];

        bool hasPermissionToCreate = false;

        for (var userRole in roles) {
          if (permissionService.hasPermission(
            userRole.permissionId,
            'createResearch',
          )) {
            hasPermissionToCreate = true;
            break;
          }
        }

        setState(() {
          canCreateResearch = hasPermissionToCreate;
          isLoadingPermissions = false;
        });
      } else {
        setState(() => isLoadingPermissions = false);
      }
    } catch (e) {
      setState(() => isLoadingPermissions = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              AppSearchBar(
                controller: searchController,
                hintText: 'Buscar pesquisas...',
              ),
              const SizedBox(height: 20),
              CardCarousel(
                title: 'Questionários Modelos',
                cards: [
                  QuestCard(
                    title: 'EDQ - Quest R8',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {},
                  ),
                  QuestCard(
                    title: 'EVTR - Alg 1',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {},
                  ),
                  QuestCard(
                    title: 'RSI - Alg 2',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {},
                  ),
                ],
              ),
              CardCarousel(
                title: 'Pesquisas Recentes',
                cards: [
                  ResearchCard(
                    title: 'EDQ - Alz R8',
                    participants: 20,
                    groups: 2,
                    researchers: 3,
                    onTap: () {},
                  ),
                  ResearchCard(
                    title: 'EVTR - Alg 1',
                    participants: 25,
                    groups: 2,
                    researchers: 4,
                    onTap: () {},
                  ),
                  ResearchCard(
                    title: 'RSI - Alg 2',
                    participants: 10,
                    groups: 2,
                    researchers: 5,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isLoadingPermissions) ...[
                if (canCreateResearch) ...[
                  ActionButton(
                    text: 'Nova Pesquisa',
                    onPressed: () {},
                    isDark: false,
                  ),
                  const SizedBox(height: 10),
                ],
              ],
              ActionButton(
                text: 'Novo Questionário',
                onPressed: () {},
                isDark: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
