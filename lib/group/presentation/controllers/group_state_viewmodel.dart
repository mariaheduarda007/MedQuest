import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/group/presentation/widgets/patient_filter.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum PatientSuccessEvent { created }
enum GroupSuccessEvent { deleted }

class GroupStateViewModel {
  final state = Signal<Group?>(null);
  final patientsState = Signal<List<Patient>?>(null);
  final patientState = Signal<Patient?>(null);
  PatientFilterType selectedFilter = PatientFilterType.all;

  final message = signal<String?>(null);
  final patientsMessage = signal<String?>(null);
  final patientMessage = signal<String?>(null);

  final successEvent = signal<GroupSuccessEvent?>(null);
  final patientSuccessEvent = signal<PatientSuccessEvent?>(null);

  late final hasGroup = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  // late final isEditing = computed(() => hasGroup.value);

  // late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setGroup(Group? group) => state.value = group;
  void setPatients(List<Patient>? patients) => patientsState.value = patients;
  void setPatient(Patient? patient) => patientState.value = patient;

  void clearMessage() => message.value = null;
  void setMessage(String msg) => message.value = msg;

  void clearPatientsMessage() => patientsMessage.value = null;
  void setPatientsMessage(String msg) => patientsMessage.value = msg;

  void clearPatientMessage() => patientMessage.value = null;
  void setPatientMessage(String msg) => patientMessage.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
  void clearPatientSuccessEvent() => patientSuccessEvent.value = null;
}
