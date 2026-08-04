import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    // Timer simulando carregamento
    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    // pega cores dinamicamente do tema ativo
    // final isDark = AppTheme.currentMode(context);
    // final backgroundColor = AppColors.background(context);
    // final iconColor = AppColors.primary(context);
    // final textColor = AppColors.text(context);

    final backgroundColor = context.colors.surface;
    final iconColor = context.colors.inversePrimary;
    final textColor = context.colors.onSurface;
    final progressColor = iconColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 72, color: iconColor),
            const SizedBox(height: 16),
            Text(
              'Autenticação de Usuário',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: textColor),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: progressColor,
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
