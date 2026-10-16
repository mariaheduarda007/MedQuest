import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  bool _obscure = true;

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
        _showSnack('Usuário cadastrado com sucesso! Bem-vindo, ${auth.user.name}.');
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
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe seu nome' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _emailCtrl,
                      labelText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe seu e-mail';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _passCtrl,
                      labelText: 'Senha',
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: context.colors.outline,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe sua senha';
                        if (v.length < 6) return 'Senha muito curta';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InputTextField(
                      controller: _confirmCtrl,
                      labelText: 'Confirmar senha',
                      obscureText: _obscure,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Confirme sua senha';
                        if (v != _passCtrl.text) return 'Senhas não coincidem';
                        return null;
                      },
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
                        child: ElevatedButton(
                          onPressed: isExecuting ? null : _submit,
                          child: isExecuting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Criar conta',
                                  style: TextStyle(
                                    color: context.colors.onSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const InputTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: context.colors.onSurface),
      cursorColor: context.colors.secondary,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}