import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/modelquest/data/service/modelquest_firestore_interface.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/modelquest_mapper.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/domain/models/question_mapper.dart';
import 'package:medquest/research/domain/models/research_mapper.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/result.dart';

final class ModelQuestFirestoreService implements IModelQuestFirestore {
  static const String _collection = 'ModelQuest';

  final FirebaseFirestore _firestore;

  ModelQuestFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<ModelQuestResult> createModelQuest(ModelQuest modelQuest) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .add(ModelQuestMapper.toMap(modelQuest));

      final modelQuestCreated = await getModelQuest(snapshot.id);

      return modelQuestCreated;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao salvar modelQuest: $e'),
      );
    }
  }

  @override
  Future<ModelQuestResult> getModelQuest(String modelQuestId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(modelQuestId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final modelQuest = ModelQuestMapper.fromMap(snapshot.data()!);

      return Success(modelQuest);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter modelQuest: $e'));
    }
  }

  @override
  Future<ModelQuestsResult> getAllModelQuests() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final modelQuests = snapshot.docs
          .map((doc) => ModelQuestMapper.fromMap(doc.data()))
          .toList();

      return Success(modelQuests);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao obter modelQuests: $e'),
      );
    }
  }

  @override
  Future<ModelQuestsResult> getModelQuestsFromResearch(
    String researchId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .where(FieldPath.documentId, isEqualTo: researchId)
          .get();

      if (!snapshot.docs.isNotEmpty) {
        return Error(EmptyResultFailure());
      }
      final research = ResearchMapper.fromMap(snapshot.docs.first.data());
      final modelQuests = await getModelQuests(research.quests);

      return modelQuests;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao obter modelQuests: $e'),
      );
    }
  }

  Future<ModelQuestsResult> getModelQuests(List<String> modelQuestIds) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where(FieldPath.documentId, whereIn: modelQuestIds)
          .get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final modelQuests = snapshot.docs
          .map((doc) => ModelQuestMapper.fromMap(doc.data()))
          .toList();

      return Success(modelQuests);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao obter modelQuests: $e'),
      );
    }
  }

  @override
  Future<ModelQuestResult> updateModelQuest(ModelQuest modelQuest) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(modelQuest.id)
          .update(ModelQuestMapper.toMap(modelQuest));

      final updatedModelQuest = await getModelQuest(modelQuest.id);

      return updatedModelQuest;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao atualizar modelQuest: $e'),
      );
    }
  }

  @override
  Future<VoidResult> deleteModelQuest(String modelQuestId) async {
    try {
      await _firestore.collection(_collection).doc(modelQuestId).delete();

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao deletar modelQuest: $e'),
      );
    }
  }

  @override
  Future<QuestionResult> createQuestion(String modelQuestId, Question question) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(modelQuestId)
          .collection('Questions')
          .add(QuestionMapper.toMap(question));

      final questionCreated = await getQuestion(modelQuestId, snapshot.id);

      return questionCreated;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao salvar question: $e'),
      );
    }
  }

  Future<QuestionResult> getQuestion(String modelQuestId, String questionId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(modelQuestId)
          .collection('Questions')
          .doc(questionId)
          .get();

      final questionUpdated = await getQuestion(modelQuestId, snapshot.id);

      return questionUpdated;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao salvar question: $e'),
      );
    }
  }

  @override
  Future<QuestionResult> updateQuestion(String modelQuestId, Question question) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(modelQuestId)
          .collection('Questions')
          .doc(question.id)
          .update(QuestionMapper.toMap(question));

      final questionUpdated = await getQuestion(modelQuestId, question.id);

      return questionUpdated;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao salvar question: $e'),
      );
    }
  }

  @override
  Future<VoidResult> deleteQuestion(String modelQuestId, String questionId) async {
    try {
      await _firestore.collection(_collection).doc(modelQuestId).collection('Questions').doc(questionId).delete();

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao deletar question: $e'),
      );
    }
  }



}
