import 'package:medquest/research/data/repository/research_repository.dart';
import 'package:medquest/research/data/service/research_firestore_interface.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import '../../../core/typedefs/type_defs.dart';

final class ResearchRepositoryImpl implements IResearchRepository {
  final IResearchFirestore _firestore;

  ResearchRepositoryImpl({required IResearchFirestore firestore})
    : _firestore = firestore;

  @override
  Future<ResearchResult> createResearch(
    Research research
  ) {
    return _firestore.createResearch(research);
  }

  @override
  Future<ResearchResult> getResearch(
    String researchId
  ) {
    return _firestore.getResearch(researchId);
  }

  @override
  Future<ResearchesResult> getResearches(List<String> researchIds) {
    return _firestore.getResearches(researchIds);
  }

  @override
  Future<ResearchResult> updateResearch(
    Research research
  ) {
    return _firestore.updateResearch(research);
  }

  @override
  Future<VoidResult> deleteResearch(
    String researchId
  ) {
    return _firestore.deleteResearch(researchId);
  }
  
  @override
  Future<VoidResult> archiveResearch(String researchId) {
    return _firestore.archiveResearch(researchId);
  }
  
  
  @override
  Future<VoidResult> unarchiveResearch(String researchId) {
    return _firestore.unarchiveResearch(researchId);
  }
}
