import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/answeredquest/data/service/answeredquest_firestore_interface.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_mapper.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/result.dart';

final class AnsweredQuestFirestoreService implements IAnsweredQuestFirestore {
  static const String _collection = 'AnsweredQuest';

  final FirebaseFirestore _firestore;

  AnsweredQuestFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<AnsweredQuestResult> createAnsweredQuest(
    AnsweredQuest answeredQuest,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .add(AnsweredQuestMapper.toMap(answeredQuest));
      final questCreated = await getAnsweredQuest(snapshot.id);

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
  Future<AnsweredQuestResult> getAnsweredQuest(String answeredQuestId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(answeredQuestId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final answeredQuest = AnsweredQuestMapper.fromMap(snapshot.data()!);

      return Success(answeredQuest);
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao obter questionário respondido: $e',
        ),
      );
    }
  }

  @override
  Future<AnsweredQuestsResult> getAnsweredQuests(String patientId) async {
    try {
      final snapshot = await _firestore
          .collection("Patient")
          .doc(patientId)
          .collection(_collection)
          .get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final answeredQuests = snapshot.docs
          .map((doc) => AnsweredQuestMapper.fromMap(doc.data()))
          .toList();

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
    AnsweredQuest answeredQuest,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(answeredQuest.id)
          .update(AnsweredQuestMapper.toMap(answeredQuest));

      final updated = await getAnsweredQuest(answeredQuest.id);

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
  Future<VoidResult> deleteAnsweredQuest(String answeredQuestId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(answeredQuestId)
          .delete();

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure(
          'Firestore - Erro ao deletar questionário respondido: $e',
        ),
      );
    }
  }
}
