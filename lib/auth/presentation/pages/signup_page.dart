import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/validators/email_validator.dart';
import 'package:medquest/core/validators/empty_str_validator.dart';
import 'package:medquest/core/validators/password_cascade_validator.dart';
import 'package:medquest/core/validators/password_confirmation_validator.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/input_text_field.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/routes/auth_routes.dart';
import 'package:medquest/core/theme/theme.dart';
import '../controllers/auth_session_viewmodel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final AuthViewModel _authController;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    _authController = injector.get<AuthViewModel>();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    try {
      await _authController.commands.signUp(
        email: email,
        password: pass,
        name: name,
      );

      if (_authController.session.message.value != null) {
        _showSnack(_authController.session.message.value!);
        return;
      }

      final auth = _authController.session.session.value;
      if (auth == null) {
        _showSnack('Falha ao cadastrar usuário.');
      } else {
        _showSnack(
          'Usuário cadastrado com sucesso! Bem-vindo, ${auth.user.name}.',
        );
        context.go(AuthRouteNames.login);
      }
    } catch (e) {
      _showSnack('Erro ao fazer cadastro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: context.colors.secondary,
        foregroundColor: context.colors.onSecondary,
      ),
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
                    InputTextField(
                      controller: _nameCtrl,
                      labelText: 'Nome',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          validateField(value, [EmptyStrValidator()]),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _emailCtrl,
                      labelText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          validateField(value, [EmailValidator()]),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _passCtrl,
                      labelText: 'Senha',
                      password: true,
                      validator: (value) =>
                          validateField(value, [PasswordCascadeValidator()]),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _confirmCtrl,
                      labelText: 'Confirmar senha',

                      validator: (value) => validateField(value, [
                        PasswordConfirmationValidator(_passCtrl.text),
                      ]),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Watch((context) {
                      final isExecuting = _authController
                          .commands
                          .signUpCommand
                          .isExecuting
                          .value;

                      return SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          onPressed: _submit,
                          text: 'Criar conta',
                          isLoading: isExecuting,
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => context.go(AuthRouteNames.login),
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.secondary,
                      ),
                      child: const Text('Já tem conta? Login'),
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
