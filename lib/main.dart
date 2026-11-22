import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/routes/app_routes.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependencyInjection();

  runApp(const MyApp());

  final permissionService = injector.get<PermissionCacheService>();
  permissionService
      .loadPermissions()
      .then((_) {
        log('${permissionService.allPermissions}', name: 'Permission Check');
      })
      .catchError((Object error) {
        log('Erro ao carregar permissoes: $error', name: 'Permission Check');
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MedQuest',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: AppRouter.router,
    );
  }
}
