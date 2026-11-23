import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade AnsweredQuest que serão consumidas na UI
enum AnsweredQuestSuccessEvent { created, updated, deleted }

class AnsweredQuestStateViewModel {
  final state = Signal<AnsweredQuest?>(null);
  final answeredQuestsState = Signal<List<AnsweredQuest>>([]);

  final message = signal<String?>(null);
  final answeredQuestSuccessEvent = signal<AnsweredQuestSuccessEvent?>(null);

  late final hasAnsweredQuest = computed(() => state.value != null);
  late final hasAnsweredQuests = computed(() => answeredQuestsState.value.isNotEmpty);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasAnsweredQuest.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setAnsweredQuest(AnsweredQuest? answeredQuest) => state.value = answeredQuest;
  void setAnsweredQuests(List<AnsweredQuest> answeredQuests) => answeredQuestsState.value = answeredQuests;

  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearAnsweredQuestSuccessEvent() => answeredQuestSuccessEvent.value = null;
}
