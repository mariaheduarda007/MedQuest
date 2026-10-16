import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import '../controllers/user_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final UserViewModel _vm;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = injector.get<UserViewModel>();
    _vm.commands.fetchUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: context.colors.secondary,
        foregroundColor: context.colors.onSecondary,
      ),
      body: Watch((context) {
        if (_vm.commands.getUserCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = _vm.userState.state.value;

        if (user == null) {
          return Center(
            child: Text(
              "Erro ao carregar perfil.",
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.error,
              ),
            ),
          );
        }

        if (_nameController.text.isEmpty) _nameController.text = user.name;
        if (_emailController.text.isEmpty) _emailController.text = user.email;

        return SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: context.colors.tertiary,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: context.colors.onSecondary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: context.colors.secondary,
                        radius: 18,
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: context.colors.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Informações pessoais
              _buildSectionTitle(context, 'Informações pessoais'),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(context, label: 'Nome', controller: _nameController),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(context, label: 'E-mail', controller: _emailController),
              
              const SizedBox(height: AppSpacing.xl),

              // Segurança
              _buildSectionTitle(context, 'Segurança'),
              const SizedBox(height: AppSpacing.md),
              _buildSecurityOption(context, Icons.lock_outline, 'Alterar senha', () {}),
              _buildSecurityOption(context, Icons.email_outlined, 'Alterar E-mail', () {}),
              _buildSecurityOption(context, Icons.person_outline, 'Alterar Nome', () {}),
              _buildSecurityOption(context, Icons.settings_outlined, 'Preferências', () {}),

              const SizedBox(height: AppSpacing.xxl),

              // Botão Sair
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => null, // Ajustar quando tiver o comando de logout
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.error,
                    side: BorderSide(color: context.colors.error),
                    padding: AppSpacing.verticalMd,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  child: const Text('Sair da conta'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.onPrimary,
          ),
        ),
      );

  Widget _buildTextField(BuildContext context, {required String label, required TextEditingController controller}) => 
    TextFormField(
      controller: controller,
      style: TextStyle(color: context.colors.onSurface),
      cursorColor: context.colors.secondary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.colors.outline),
        filled: true,
        fillColor: context.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: context.colors.outline.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: context.colors.outline.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: context.colors.secondary,
            width: 1.5,
          ),
        ),
      ),
    );

  Widget _buildSecurityOption(BuildContext context, IconData icon, String text, VoidCallback onTap) => 
    Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: context.colors.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: context.colors.secondary),
        title: Text(
          text,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: context.colors.outline),
        onTap: onTap,
      ),
    );
}