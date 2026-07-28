import 'package:flutter/material.dart';
import 'package:medquest/domain/models/group_entity.dart';
import 'package:medquest/domain/models/patient_entity.dart';
import '../failure/failure.dart';

import '../patterns/result.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
typedef PatientResult = Result<Patient, Failure>;
typedef GroupResult = Result<Group, Failure>;


// typedfs para parâmetros
typedef PatientParams = ({Patient patient, String researchId, String groupId});
typedef PatientIdParams = ({String researchId, String groupId, String patientId});
typedef GroupParams = ({Group group, String researchId});
typedef GroupIdParams = ({String researchId, String groupId});

typedef NoParams = ();


/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});


// typedfs para parâmetros
/// tipos usadoos para modulo de autenticação
typedef SignInParams = ({String email, String password});
typedef SignUpParams =
    ({String? name,String email, String password});
