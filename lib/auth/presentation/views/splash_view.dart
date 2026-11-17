import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/routes/auth_routes.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fundo da tela
          Positioned.fill(child: Container(color: context.colors.primary)),

          // Faixa decorativa lateral
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: size.width * 0.2,
            child: ClipPath(
              clipper: SplashSideClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, // Onde o gradiente começa
                    end: Alignment.bottomCenter, // Onde o gradiente termina
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.onPrimary, // Cor inicial (topo)
                      Theme.of(
                        context,
                      ).colorScheme.tertiary, // Cor final (base)
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.15,
                right: size.width * 0.09,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const MedQuestLogo(),
                  const SizedBox(height: 48),

                  Text(
                    'Bem-vindo!',
                    style: context.textStyles.displayLarge?.regular.withColor(
                      context.colors.tertiary,
                    ),
                  ),

                  const Spacer(flex: 2),

                  Center(
                    child: ActionButton(
                      text: 'Entrar',
                      variant: ActionButtonVariant.outlined,
                      size: ActionButtonSize.lg,
                      onPressed: () {
                        context.goNamed(AuthRouteNames.login);
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  Center(
                    child: ActionButton(
                      text: 'Cadastrar-se',
                      variant: ActionButtonVariant.filled,
                      size: ActionButtonSize.lg,
                      onPressed: () {
                        context.goNamed(AuthRouteNames.register);
                      },
                    ),
                  ),

                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashSideClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.12, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant SplashSideClipper oldClipper) {
    return false;
  }
}
