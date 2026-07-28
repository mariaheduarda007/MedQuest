import 'package:medquest/domain/models/group_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade Group que serão consumidas na UI
enum GroupSuccessEvent { created, deleted }

class GroupStateViewModel {
  final state = Signal<Group?>(null);

  final message = signal<String?>(null);

  /// Evento de sucesso para operações de conta, inicializado como nulo
  final successEvent = signal<GroupSuccessEvent?>(null);

  late final hasGroup = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  // late final isEditing = computed(() => hasGroup.value);

  // late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setGroup(Group? group) => state.value = group;

  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
