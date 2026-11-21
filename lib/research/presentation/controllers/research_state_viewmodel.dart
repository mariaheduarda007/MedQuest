import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/research/domain/models/score_chart_data.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade Research que serão consumidas na UI
enum ResearchSuccessEvent { created, updated, deleted, archived, unarchived }

class ResearchStateViewModel {
  final state = Signal<Research?>(null);

  // final researchesState = Signal<List<Research>?>(null);
  final groupsState = Signal<List<Group>>([]);
  final modelQuestsState = Signal<List<ModelQuest>>([]);

  final message = signal<String?>(null);
  final groupsMessage = signal<String?>(null);
  final modelQuestsMessage = signal<String?>(null);

  final scoreChartDataState = Signal<Map<String, List<ScoreChartData>>>({});
  final scoreChartMessage = signal<String?>(null);

  /// Evento de sucesso para operações de conta, inicializado como nulo
  final successEvent = signal<ResearchSuccessEvent?>(null);

  late final hasResearch = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasResearch.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  // void setResearches(List<Research>? researches) => researchesState.value = researches;
  void setResearch(Research? research) => state.value = research;

  void setGroups(List<Group> groups) => groupsState.value = groups;

  void setModelQuests(List<ModelQuest> modelQuests) =>
      modelQuestsState.value = modelQuests;

  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  void clearGroupsMessage() => groupsMessage.value = null;

  void setGroupsMessage(String msg) => groupsMessage.value = msg;

  void clearModelQuestsMessage() => modelQuestsMessage.value = null;

  void setModelQuestsMessage(String msg) => modelQuestsMessage.value = msg;

  void setScoreChartData(Map<String, List<ScoreChartData>> data) {
    scoreChartDataState.value = data;
  }

  void clearScoreChartDataMessage() {
    scoreChartMessage.value = null;
  }

  void setScoreChartDataMessage(String msg) {
    scoreChartMessage.value = msg;
  }

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
