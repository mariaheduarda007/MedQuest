import 'package:flutter/material.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import '../failure/failure.dart';
import '../patterns/result.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/research/domain/models/research_entity.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
typedef PatientResult = Result<Patient, Failure>;
typedef PatientsResult = Result<List<Patient>, Failure>;
typedef GroupResult = Result<Group, Failure>;
typedef GroupsResult = Result<List<Group>, Failure>;
typedef ResearchResult = Result<Research, Failure>;
typedef ResearchesResult = Result<List<Research>, Failure>;
typedef ModelQuestResult = Result<ModelQuest, Failure>;
typedef ModelQuestsResult = Result<List<ModelQuest>, Failure>;
typedef QuestionResult = Result<Question, Failure>;




// typedfs para parâmetros
typedef PatientParams = ({Patient patient, String researchId, String groupId});
typedef PatientIdParams = ({String researchId, String groupId, String patientId});
typedef GroupParams = ({Group group, String researchId});
typedef GroupIdParams = ({String researchId, String groupId});
typedef ResearchParams = ({Research research});
typedef ResearchIdParams = ({String researchId});
typedef ResearchesIdParams = ({List<String> researchesId});
typedef ModelQuestParams = ({ModelQuest modelQuest});
typedef ModelQuestIdParams = ({String modelQuestId});
typedef ModelQuestsIdParams = ({List<String> modelQuestsId});
typedef QuestionParams = ({String modelQuestId, Question question});
typedef NoParams = ();

// LEMBRAR DE SIMPLIFICAR QUANDO FOR UM PARAMETRO COMO STRING, UM INT, UM BOOL, ETC. NAO PRECISA DE RECORD, PODE SER DIRETO COMO PARAMETRO DO METODO
// typedef ResearchId = String;
// typedef GroupId = String;
// typedef PatientId = String;



/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});


/// typedefs para modulo de autenticação
typedef SignInParams = ({String email, String password});
typedef SignUpParams =
    ({String? name,String email, String password});
