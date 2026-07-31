import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/research/data/service/research_firestore_interface.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/domain/models/research_mapper.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/result.dart';

final class ResearchFirestoreService implements IResearchFirestore {
  static const String _collection = 'Research';

  final FirebaseFirestore _firestore;

  ResearchFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<ResearchResult> createResearch(Research research) async {
    try {
      await _firestore
          .collection(_collection)
          .add(ResearchMapper.toMap(research));

      final researchCreated = await getResearch(research.id);

      if (researchCreated is Error) {
        return Error(ApiLocalFailure('Firestore - Erro ao obter pesquisa criada'));
      }

      return researchCreated;
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao salvar pesquisa: $e'));
    }
  }

  @override
  Future<ResearchResult> getResearch(String researchId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(researchId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final research = ResearchMapper.fromMap(snapshot.data()!);

      return Success(research);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter pesquisa: $e'));
    }
  }

  @override
  Future<ResearchesResult> getResearches(List<String> researchIds) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where(FieldPath.documentId, whereIn: researchIds)
          .get();

      if (!snapshot.docs.isNotEmpty) {
        return Error(EmptyResultFailure());
      }

      final researches = snapshot.docs.map((doc) => ResearchMapper.fromMap(doc.data())).toList();

      return Success(researches);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter pesquisa: $e'));
    }
  }

  @override
  Future<ResearchResult> updateResearch(
    Research research,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(research.id)
          .update(ResearchMapper.toMap(research));

      final updatedResearch = await getResearch(research.id);

      return updatedResearch;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao atualizar pesquisa: $e'),
      );
    }
  }

  @override
  Future<VoidResult> deleteResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).delete();

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao deletar pesquisa: $e'));
    }
  }

  @override
  Future<VoidResult> archiveResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).update({
        'archived': true,
      });

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao arquivar pesquisa: $e'),
      );
    }
  }

  @override
  Future<VoidResult> unarchiveResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).update({
        'archived': false,
      });

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao desarquivar pesquisa: $e'),
      );
    }
  }
}
