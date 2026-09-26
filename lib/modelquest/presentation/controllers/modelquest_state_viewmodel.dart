import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade ModelQuest que serão consumidas na UI
enum ModelQuestSuccessEvent { created, updated, deleted }
enum QuestionSuccessEvent { created, updated, deleted }

class ModelQuestStateViewModel {
  final modelQuestState = Signal<ModelQuest?>(null);
  final modelQuestsState = Signal<List<ModelQuest>>([]);
  final questionState = Signal<Question?>(null);
  final questionsState = Signal<List<Question>>([]);
  final message = signal<String?>(null);
  final modelQuestSuccessEvent = signal<ModelQuestSuccessEvent?>(null);
  final questionSuccessEvent = signal<QuestionSuccessEvent?>(null);

  late final hasModelQuest = computed(() => modelQuestState.value != null);
  late final isEditing = computed(() => hasModelQuest.value);
  late final canDelete = computed(() => isEditing.value);

  void setModelQuest(ModelQuest? modelQuest) => modelQuestState.value = modelQuest;
  void setModelQuests(List<ModelQuest> modelQuests) => modelQuestsState.value = modelQuests;
  void setQuestion(Question? question) => questionState.value = question;
  void setQuestions(List<Question> questions) => questionsState.value = questions;

  void clearMessage() => message.value = null;
  void setMessage(String msg) => message.value = msg;
  void clearModelQuestSuccessEvent() => modelQuestSuccessEvent.value = null;
  void clearQuestionSuccessEvent() => questionSuccessEvent.value = null; 
}
