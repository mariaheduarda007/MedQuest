import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum UserSuccessEvent { created, updated, deleted }


class UserStateViewModel {
  final state = Signal<User?>(null);

  final message = signal<String?>(null);

  final successEvent = signal<UserSuccessEvent?>(null);

  late final hasUser = computed(() => state.value != null);

  late final isEditing = computed(() => hasUser.value);

  late final canDelete = computed(() => isEditing.value);

  late final title = computed(
    () => isEditing.value ? 'Editar Conta' : 'Criar Conta',
  );

  late final labelEditMode = computed(
    () => isEditing.value ? 'SALVAR' : 'CRIAR',
  );

  // atualiza o estado da conta
  void setUser(User? user) => state.value = user;

  // limpa qualquer mensagem de erro ou aviso
  void clearMessage() => message.value = null;

  // define uma mensagem de erro ou aviso
  void setMessage(String msg) => message.value = msg;

  // limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
