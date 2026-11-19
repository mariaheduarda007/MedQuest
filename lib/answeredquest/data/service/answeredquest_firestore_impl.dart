import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/answeredquest/data/service/answeredquest_firestore_interface.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_mapper.dart';
import 'package:medquest/answeredquest/domain/models/question_mapper.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/result.dart';

final class AnsweredQuestFirestoreService implements IAnsweredQuestFirestore {
  static const String _collection = 'AnsweredQuest';

  final FirebaseFirestore _firestore;

  AnsweredQuestFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<AnsweredQuestResult> createAnsweredQuest(
    AnsweredQuestParams params,
  ) async {
    try {
      final answeredQuest = params.answeredQuest;
      final patientIdParams = params.patientIdParams;

      final collection = _answeredQuestsCollection(
        researchId: patientIdParams.researchId,
        groupId: patientIdParams.groupId,
        patientId: patientIdParams.patientId,
      );

      //contando quantas vezes ja respondeu esse questionario
      final existingQuestsQuery = await collection
          .where('idModelQuest', isEqualTo: answeredQuest.idModelQuest)
          .get();

      int existingCount = existingQuestsQuery.docs.length;

      //formatando o nome
      String timePoint = 'T$existingCount';
      String computedName = '$timePoint ${answeredQuest.name}';

      final processedQuest = answeredQuest.copyWith(name: computedName);

      final document = collection.doc();
      await document.set(AnsweredQuestMapper.toMap(processedQuest));

      final questionsCollection = document.collection('Questions');
      for (final question in processedQuest.questions) {
        await questionsCollection.add(QuestionMapper.toMap(question));
      }

      final questCreated = await getAnsweredQuest((
        researchId: patientIdParams.researchId,
        groupId: patientIdParams.groupId,
        patientId: patientIdParams.patientId,
        answeredQuestId: document.id,
      ));

      return questCreated;
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao aplicar questionário respondido: $e',
        ),
      );
    }
  }

  @override
  Future<AnsweredQuestResult> getAnsweredQuest(
    AnsweredQuestIdParams params,
  ) async {
    try {
      final currentSnapshot = await _answeredQuestsCollection(
        researchId: params.researchId,
        groupId: params.groupId,
        patientId: params.patientId,
      ).doc(params.answeredQuestId).get();

      if (currentSnapshot.exists && currentSnapshot.data() != null) {
        return Success(await _answeredQuestFromDocument(currentSnapshot));
      }

      return Error(
        EmptyResultFailure(
          'Questionário ${params.answeredQuestId} não encontrado em '
          'Research/${params.researchId}/Group/${params.groupId}/'
          'Patient/${params.patientId}/$_collection.',
        ),
      );
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao obter questionário respondido: $e',
        ),
      );
    }
  }

  @override
  Future<AnsweredQuestsResult> getAnsweredQuests(PatientParams params) async {
    try {
      final snapshot = await _answeredQuestsCollection(
        researchId: params.researchId,
        groupId: params.groupId,
        patientId: params.patient.id,
      ).get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final answeredQuests = await Future.wait(
        snapshot.docs.map(_answeredQuestFromDocument),
      );

      return Success(answeredQuests);
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao obter questionários respondidos: $e',
        ),
      );
    }
  }

  @override
  Future<AnsweredQuestResult> updateAnsweredQuest(
    AnsweredQuestParams params,
  ) async {
    try {
      final answeredQuest = params.answeredQuest;
      final patientIdParams = params.patientIdParams;
      final document = _answeredQuestsCollection(
        researchId: patientIdParams.researchId,
        groupId: patientIdParams.groupId,
        patientId: patientIdParams.patientId,
      ).doc(answeredQuest.id);
      await document.update(AnsweredQuestMapper.toMap(answeredQuest));
      final questionsCollection = document.collection('Questions');
      for (final question in answeredQuest.questions) {
        final questionDocument = question.id.isEmpty
            ? questionsCollection.doc()
            : questionsCollection.doc(question.id);
        await questionDocument.set(QuestionMapper.toMap(question));
      }

      final updated = await getAnsweredQuest((
        researchId: patientIdParams.researchId,
        groupId: patientIdParams.groupId,
        patientId: patientIdParams.patientId,
        answeredQuestId: answeredQuest.id,
      ));

      return updated;
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao atualizar questionário respondido: $e',
        ),
      );
    }
  }

  @override
  Future<VoidResult> deleteAnsweredQuest(AnsweredQuestIdParams params) async {
    try {
      await _answeredQuestsCollection(
        researchId: params.researchId,
        groupId: params.groupId,
        patientId: params.patientId,
      ).doc(params.answeredQuestId).delete();

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao deletar questionário respondido: $e',
        ),
      );
    }
  }

  Future<AnsweredQuest> _answeredQuestFromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    final data = document.data();
    if (data == null) {
      throw StateError('Documento AnsweredQuest sem dados: ${document.id}');
    }

    final answeredQuest = AnsweredQuestMapper.fromMap(
      data,
      documentId: document.id,
    );
    final questionsSnapshot = await document.reference
        .collection('Questions')
        .get();
    if (questionsSnapshot.docs.isEmpty) {
      return answeredQuest;
    }

    final questions = questionsSnapshot.docs
        .map(
          (questionDocument) => QuestionMapper.fromMap(
            questionDocument.data(),
            documentId: questionDocument.id,
          ),
        )
        .toList();

    return answeredQuest.copyWith(questions: questions);
  }

  CollectionReference<Map<String, dynamic>> _answeredQuestsCollection({
    required String researchId,
    required String groupId,
    required String patientId,
  }) {
    return _firestore
        .collection('Research')
        .doc(researchId)
        .collection('Group')
        .doc(groupId)
        .collection('Patient')
        .doc(patientId)
        .collection(_collection);
  }
}
