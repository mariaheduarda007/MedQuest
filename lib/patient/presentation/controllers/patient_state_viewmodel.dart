import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

import '../../domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade Patient que serão consumidas na UI
enum PatientSuccessEvent { created, updated, deleted }
enum AnsweredQuestSuccessEvent { created, updated, deleted }

class PatientStateViewModel {
  final state = Signal<Patient?>(null);
  final patientsState = Signal<List<Patient>>([]);
  final answeredQuestState = Signal<AnsweredQuest?>(null);
  final answeredQuestsState = Signal<List<AnsweredQuest>>([]);

  final message = signal<String?>(null);
  final patientSuccessEvent = signal<PatientSuccessEvent?>(null);
  final answeredQuestSuccessEvent = signal<AnsweredQuestSuccessEvent?>(null);

  late final hasPatient = computed(() => state.value != null);
  late final hasPatients = computed(() => patientsState.value.isNotEmpty);
  late final hasAnsweredQuest = computed(() => answeredQuestState.value != null);
  late final hasAnsweredQuests = computed(() => answeredQuestsState.value.isNotEmpty);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasPatient.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setPatient(Patient? patient) => state.value = patient;
  void setPatients(List<Patient> patients) => patientsState.value = patients;
  void setAnsweredQuest(AnsweredQuest? answeredQuest) => answeredQuestState.value = answeredQuest;
  void setAnsweredQuests(List<AnsweredQuest> answeredQuests) => answeredQuestsState.value = answeredQuests;

  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearPatientSuccessEvent() => patientSuccessEvent.value = null;
  void clearAnsweredQuestSuccessEvent() => answeredQuestSuccessEvent.value = null;
}
