import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/dependency_injection.dart'; 
import '../controllers/user_viewmodel.dart'; 

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Injeção de dependência via Service Locator
  late final UserViewModel _vm;
  
  // Controllers para os campos editáveis
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = injector.get<UserViewModel>();

    // Busca os dados do usuário usando o padrão de Commands
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
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Watch((context) {
        // Observa o estado de execução do comando
        if (_vm.commands.getUserCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = _vm.userState.state.value;

        // Caso o usuário não seja encontrado ou não carregado
        if (user == null) {
          return const Center(child: Text("Erro ao carregar perfil."));
        }

        // Sincroniza os controllers com o dado carregado
        if (_nameController.text.isEmpty) _nameController.text = user.name;
        if (_emailController.text.isEmpty) _emailController.text = user.email;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                    Positioned(
                      bottom: 0, right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 18,
                        child: const Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Informações pessoais
              _buildSectionTitle('Informações pessoais'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Nome', controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField(label: 'E-mail', controller: _emailController),
              
              const SizedBox(height: 32),

              // Segurança
              _buildSectionTitle('Segurança'),
              const SizedBox(height: 16),
              _buildSecurityOption(context, Icons.lock_outline, 'Alterar senha', () {}),
              _buildSecurityOption(context, Icons.email_outlined, 'Alterar E-mail', () {}),
              _buildSecurityOption(context, Icons.person_outline, 'Alterar Nome', () {}),
              _buildSecurityOption(context, Icons.settings_outlined, 'Preferências', () {}),

              const SizedBox(height: 40),

              // Botão Sair
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  // onPressed: () => _vm.commands.logout(),
                  onPressed: () => null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildSectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField({required String label, required TextEditingController controller}) => 
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );

  Widget _buildSecurityOption(BuildContext context, IconData icon, String text, VoidCallback onTap) => 
    Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
}