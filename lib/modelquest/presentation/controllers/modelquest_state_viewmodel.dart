import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade ModelQuest que serão consumidas na UI
enum ModelQuestSuccessEvent { created, updated, deleted }

enum QuestionSuccessEvent { created, updated, deleted }

class ModelQuestStateViewModel {
  final state = Signal<ModelQuest?>(null);
  final modelQuestsState = Signal<List<ModelQuest>>([]);
  final questionState = Signal<Question?>(null);
  final questionsState = Signal<List<Question>>([]);
  final message = signal<String?>(null);
  final modelQuestSuccessEvent = signal<ModelQuestSuccessEvent?>(null);
  final questionSuccessEvent = signal<QuestionSuccessEvent?>(null);
  final canDeleteModelQuest = signal(false);
  final isLoadingPermissions = signal(true);
  final permissionMessage = signal<String?>(null);

  late final hasModelQuest = computed(() => state.value != null);
  late final isEditing = computed(() => hasModelQuest.value);
  late final canDelete = computed(() => isEditing.value);

  void setModelQuest(ModelQuest? modelQuest) => state.value = modelQuest;
  void setModelQuests(List<ModelQuest> modelQuests) =>
      modelQuestsState.value = modelQuests;
  void setQuestion(Question? question) => questionState.value = question;
  void setQuestions(List<Question> questions) =>
      questionsState.value = questions;

  void clearMessage() => message.value = null;
  void setMessage(String msg) => message.value = msg;
  void clearModelQuestSuccessEvent() => modelQuestSuccessEvent.value = null;
  void clearQuestionSuccessEvent() => questionSuccessEvent.value = null;

  void setCanDeleteModelQuest(bool value) => canDeleteModelQuest.value = value;
  void setLoadingPermissions(bool value) => isLoadingPermissions.value = value;
  void clearPermissionMessage() => permissionMessage.value = null;
  void setPermissionMessage(String value) => permissionMessage.value = value;
}
