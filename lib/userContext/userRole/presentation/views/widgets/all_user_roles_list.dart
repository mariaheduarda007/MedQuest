import 'package:flutter/material.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/dependency_injection.dart';
import '../../controllers/userRole_viewmodel.dart';

class AllUserRolesList extends StatefulWidget {
  const AllUserRolesList({super.key});

  @override
  State<AllUserRolesList> createState() => _AllUserRolesListState();
}

class _AllUserRolesListState extends State<AllUserRolesList> {
  late final UserRoleViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = injector.get<UserRoleViewModel>();
    
    _vm.commands.fetchAllUserRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento Global de Papéis'),
        centerTitle: true,
      ),
      body: Watch((context) {
        // 1) Indicador de carregamento
        if (_vm.commands.getAllUserRolesCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final roles = _vm.userRoleState.state.value;

        // 2) Exibe mensagem se estiver vazio
        if (roles.isEmpty) {
          return const Center(
            child: Text("Nenhum papel cadastrado no sistema."),
          );
        }

        // 3) Lista de papéis globais
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text('Usuário ID: ${role.userId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Permission ID: ${role.permissionId}'),
                    Text('Research ID: ${role.researchId ?? "N/A"}'),
                  ],
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão Editar
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showRoleDialog(context, existingRole: role),
                    ),
                    // Botão Excluir
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _vm.commands.deleteUserRole(role.id);
                        _vm.commands.fetchAllUserRoles(); // Atualiza a lista
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Diálogo para Criar ou Editar uma Role (com campo para digitar o User ID já que estamos no modo global)
  void _showRoleDialog(BuildContext context, {UserRoleModel? existingRole}) {
    final userController = TextEditingController(text: existingRole?.userId ?? '');
    final permissionController = TextEditingController(text: existingRole?.permissionId ?? '');
    final researchController = TextEditingController(text: existingRole?.researchId ?? '');
    final isEditing = existingRole != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Papel' : 'Atribuir Novo Papel'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isEditing) ...[
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(labelText: 'User ID'),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: permissionController,
                decoration: const InputDecoration(labelText: 'Permission ID'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: researchController,
                decoration: const InputDecoration(labelText: 'Research ID (Opcional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (isEditing) {
                await _vm.commands.updateUserRole(
                  userRoleId: existingRole.id,
                  permissionId: permissionController.text,
                  researchId: researchController.text.isEmpty ? null : researchController.text,
                );
              } else {
                await _vm.commands.createUserRole(
                  userId: userController.text,
                  permissionId: permissionController.text,
                  researchId: researchController.text.isEmpty ? null : researchController.text,
                );
              }
              Navigator.pop(context);
              // Atualiza a listagem geral após a ação
              _vm.commands.fetchAllUserRoles();
            },
            child: Text(isEditing ? 'Salvar' : 'Criar'),
          ),
        ],
      ),
    );
  }
}