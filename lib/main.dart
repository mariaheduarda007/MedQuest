import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:medquest/core/routes/app_routes.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependencyInjection();
await FirebaseAuth.instance.signOut();
  final permissionService = injector.get<PermissionCacheService>();

  // --- teste permissoes ---
  try {
    await permissionService.loadPermissions();
    log('${permissionService.allPermissions}', name: 'Permission Check');
  } catch (e) {
    log('Erro ao carregar permissoes: $e', name: 'Permission Check');
  }
  // -------------------------------

  runApp(const MyApp());
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