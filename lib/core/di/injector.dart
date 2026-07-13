import 'package:auto_injector/auto_injector.dart';
import '../theme/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final injector = AutoInjector();
void setupDependencyInjection() {

  injector.addSingleton<ThemeController>(ThemeController.new);
  injector.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  injector.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  injector.commit();
}
