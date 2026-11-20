import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';

import '../../domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum PatientSuccessEvent { updated, deleted }

enum AnsweredQuestSuccessEvent { created, updated, deleted }

class PatientStateViewModel {
  final state = Signal<Patient?>(null);
  // final patientsState = Signal<List<Patient>>([]);
  final answeredQuestState = Signal<AnsweredQuest?>(null);
  final answeredQuestsState = Signal<List<AnsweredQuest>>([]);
  final modelQuestsState = Signal<List<ModelQuest>>([]);

  final message = signal<String?>(null);
  final modelQuestsMessage = signal<String?>(null);
  final answeredQuestMessage = signal<String?>(null);

  final patientSuccessEvent = signal<PatientSuccessEvent?>(null);
  final answeredQuestSuccessEvent = signal<AnsweredQuestSuccessEvent?>(null);

  late final hasPatient = computed(() => state.value != null);
  // late final hasPatients = computed(() => patientsState.value.isNotEmpty);
  late final hasAnsweredQuest = computed(
    () => answeredQuestState.value != null,
  );
  late final hasAnsweredQuests = computed(
    () => answeredQuestsState.value.isNotEmpty,
  );

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasPatient.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setPatient(Patient? patient) => state.value = patient;
  // void setAnsweredQuest(AnsweredQuest? answeredQuest) =>
  //     answeredQuestState.value = answeredQuest;
  void setAnsweredQuests(List<AnsweredQuest> answeredQuests) =>
      answeredQuestsState.value = answeredQuests;
  void setModelQuests(List<ModelQuest> modelQuests) =>
      modelQuestsState.value = modelQuests;

  void clearPatientMessage() => message.value = null;
  void setPatientMessage(String msg) => message.value = msg;
  void clearModelQuestsMessage() => modelQuestsMessage.value = null;
  void setModelQuestsMessage(String msg) => modelQuestsMessage.value = msg;
  void clearAnsweredQuestsMessage() => answeredQuestMessage.value = null;
  void setAnsweredQuestsMessage(String msg) => answeredQuestMessage.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearPatientSuccessEvent() => patientSuccessEvent.value = null;
  void clearAnsweredQuestSuccessEvent() =>
      answeredQuestSuccessEvent.value = null;
}
