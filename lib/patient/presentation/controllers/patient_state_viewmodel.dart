import '../../domain/models/patient_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// ViewModel que representa os estados da entidade Patient que serão consumidas na UI
enum PatientSuccessEvent { created, updated, deleted }

class PatientStateViewModel {
  final state = Signal<Patient?>(null);

  final patientsState = Signal<List<Patient>>([]);

  final message = signal<String?>(null);

  /// Evento de sucesso para operações de conta, inicializado como nulo
  final successEvent = signal<PatientSuccessEvent?>(null);

  late final hasPatient = computed(() => state.value != null);

  /// ===== ESTADO SEMÂNTICO =====
  late final isEditing = computed(() => hasPatient.value);

  late final canDelete = computed(() => isEditing.value);

  // ----------------------------------------------------------
  // Métodos auxiliares
  // ----------------------------------------------------------
  void setPatient(Patient? patient) => state.value = patient;
  void setPatients(List<Patient> patients) => patientsState.value = patients;

  void clearMessage() => message.value = null;

  void setMessage(String msg) => message.value = msg;

  /// Limpa o evento de sucesso após ser consumido pela UI
  void clearSuccessEvent() => successEvent.value = null;
}
