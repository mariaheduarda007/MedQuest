import '../../domain/models/modelquest_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum ModelQuestsSuccessEvent { created }

class ModelQuestsStateViewModel {
  final modelQuestsState = Signal<List<ModelQuest>>([]);
  final state = signal<ModelQuest?>(null);
  final message = signal<String?>(null);
  final modelQuestSuccessEvent = signal<ModelQuestsSuccessEvent?>(null);
  final canCreateModelQuest = signal(false);
  final isLoadingPermissions = signal(true);
  final permissionMessage = signal<String?>(null);

  void setModelQuests(List<ModelQuest> modelQuests) =>
      modelQuestsState.value = modelQuests;
  void setModelQuest(ModelQuest modelQuest) => state.value = modelQuest;
  void clearMessage() => message.value = null;
  void setMessage(String msg) => message.value = msg;
  void clearModelQuestSuccessEvent() => modelQuestSuccessEvent.value = null;
  void setCanCreateModelQuest(bool value) => canCreateModelQuest.value = value;
  void setLoadingPermissions(bool value) => isLoadingPermissions.value = value;
  void clearPermissionMessage() => permissionMessage.value = null;
  void setPermissionMessage(String value) => permissionMessage.value = value;
}
