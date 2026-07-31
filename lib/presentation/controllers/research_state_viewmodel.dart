import 'package:medquest/domain/models/research_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade Research que serão consumidas na UI
enum ResearchSuccessEvent { created, updated, deleted, archived, unarchived }

class ResearchStateViewModel {
  final state = Signal<Research?>(null);

  final researchesState = Signal<List<Research>?>(null);

  final message = signal<String?>(null);

  /// Evento de sucesso para operações de conta, inicializado como nulo
  final successEvent = signal<ResearchSuccessEvent?>(null);

  late final hasResearch = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasResearch.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setResearch(Research? research) => state.value = research;

  void setResearches(List<Research>? researches) => researchesState.value = researches;


  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
