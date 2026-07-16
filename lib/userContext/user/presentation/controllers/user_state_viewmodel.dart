import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa o estado da entidade User
enum UserSuccessEvent { created, updated, deleted }

/// Define os estado da entidade User
/// que serão consumidas na UI
class UserStateViewModel {
  /// Estado da conta, inicializada como nula
  final state = Signal<User?>(null);

  /// Mensagem de erro ou aviso, inicializada como nula
  final message = signal<String?>(null);

  /// Evento de sucesso para operações de conta, inicializado como nulo
  final successEvent = signal<UserSuccessEvent?>(null);

  /// Indica se existe uma conta carregada
  late final hasUser = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasUser.value);

  late final canDelete = computed(() => isEditing.value);

  late final title = computed(
    () => isEditing.value ? 'Editar Conta' : 'Criar Conta',
  );

  late final labelEditMode = computed(
    () => isEditing.value ? 'SALVAR' : 'CRIAR',
  );

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  /// Atualiza o estado da conta
  void setUser(User? user) => state.value = user;

  /// Limpa qualquer mensagem de erro ou aviso
  void clearMessage() => message.value = null;

  /// Define uma mensagem de erro ou aviso
  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
