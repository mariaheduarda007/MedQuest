import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/validators/email_validator.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/input_text_field.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/routes/auth_routes.dart';
import '../controllers/auth_session_viewmodel.dart';
import '../widgets/auth_text_form_field.dart';
import 'package:medquest/core/theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthViewModel authController;

  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  @override
  void initState() {
    authController = injector.get<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingXl,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Bem-vindo de volta',
                      style: context.textStyles.headlineMedium?.copyWith(
                        color: context.colors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Entre para continuar',
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    InputTextField(
                      controller: emailCtrl,
                      labelText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          validateField(value, [EmailValidator()]),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: passCtrl,
                      labelText: 'Senha',
                      password: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe sua senha';
                        }
                        if (value.length < 6) {
                          return 'Senha muito curta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: context.colors.secondary,
                        ),
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Watch((context) {
                      final isRunning = authController
                          .commands
                          .signInCommand
                          .isExecuting
                          .value;

                      return ActionButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() != true) return;

                          try {
                            await authController.commands.signIn(
                              emailCtrl.text,
                              passCtrl.text,
                            );

                            if (authController.session.message.value != null) {
                              _showSnack(authController.session.message.value!);
                            }
                          } catch (e) {
                            _showSnack('Erro ao fazer login: $e');
                          }
                        },
                        isLoading: isRunning,
                        text: 'Entrar',
                        size: ActionButtonSize.md,
                        

                      );
                    }),
                    const SizedBox(height: AppSpacing.lg),

                    TextButton(
                      onPressed: () {
                        context.goNamed(AuthRouteNames.register);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.secondary,
                      ),
                      child: const Text('Não tem conta? Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
