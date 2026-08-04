import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/dependency_injection.dart';
import '../../controllers/userRole_viewmodel.dart';

class UserRolesByIdListView extends StatefulWidget {
  final String userId;

  const UserRolesByIdListView({super.key, required this.userId});

  @override
  State<UserRolesByIdListView> createState() => _UserRolesByIdListViewState();
}

class _UserRolesByIdListViewState extends State<UserRolesByIdListView> {
  late final UserRoleViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = injector.get<UserRoleViewModel>();
    
    _vm.commands.fetchUserRoles(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Papéis e Permissões'),
        centerTitle: true,
      ),
      body: Watch((context) {
        // 1) Indicador de carregamento enquanto busca os dados
        if (_vm.commands.getUserRolesCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final roles = _vm.userRoleState.state.value;

        // 2) Exibe mensagem amigável caso não tenha nenhum papel associado
        if (roles.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Nenhum papel encontrado para este usuário.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        // 3) Lista de papéis em modo estrito de visualização
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.security, color: Theme.of(context).primaryColor),
                ),
                title: Text(
                  'Permission ID: ${role.permissionId}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Research ID: ${role.researchId ?? "N/A"}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}