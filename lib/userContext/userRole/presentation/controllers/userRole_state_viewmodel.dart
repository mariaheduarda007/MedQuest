import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum UserRoleSuccessEvent { created, updated, deleted }


class UserRoleStateViewModel {
  final state = Signal<List<UserRoleModel>>([]);

  final message = signal<String?>(null);

  final successEvent = signal<UserRoleSuccessEvent?>(null);

  late final hasUserRoles = computed(() => state.value.isNotEmpty);

  late final isEmpty = computed(() => state.value.isEmpty);

  // atualiza o estado completo da lista de roles
  void setUserRoles(List<UserRoleModel> roles) => state.value = roles;

  // adiciona uma nova role na lista atual
  void addUserRole(UserRoleModel role) {
    state.value = [...state.value, role];
  }

  // remove uma role da lista pelo ID
  void removeUserRole(String userRoleId) {
    state.value = state.value.where((role) => role.id != userRoleId).toList();
  }

  // limpa qualquer mensagem de erro ou aviso
  void clearMessage() => message.value = null;

  // define uma mensagem de erro ou aviso
  void setMessage(String msg) => message.value = msg;

  // limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}