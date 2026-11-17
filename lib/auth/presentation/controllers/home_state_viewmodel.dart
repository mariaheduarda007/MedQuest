import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeStateViewModel {
  final researchesState = Signal<List<Research>>([]);
  final modelQuestsState = Signal<List<ModelQuest>>([]);
  final researchesMessage = signal<String?>(null);
  final modelQuestsMessage = signal<String?>(null);
  final canCreateResearch = signal(false);
  final isLoadingPermissions = signal(true);
  final permissionMessage = signal<String?>(null);

  void setResearches(List<Research> researches) =>
      researchesState.value = researches;

  void setModelQuests(List<ModelQuest> modelQuests) =>
      modelQuestsState.value = modelQuests;

  void clearResearchesMessage() => researchesMessage.value = null;

  void setResearchesMessage(String value) => researchesMessage.value = value;

  void clearModelQuestsMessage() => modelQuestsMessage.value = null;

  void setModelQuestsMessage(String value) => modelQuestsMessage.value = value;

  void setCanCreateResearch(bool value) => canCreateResearch.value = value;

  void setLoadingPermissions(bool value) => isLoadingPermissions.value = value;

  void clearPermissionMessage() => permissionMessage.value = null;

  void setPermissionMessage(String value) => permissionMessage.value = value;
}
