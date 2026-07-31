import '../../core/typedefs/type_defs.dart';
import '../../domain/models/research_entity.dart';

abstract interface class IResearchFirestore {
  Future<ResearchResult> createResearch(
    Research research,
  );
  Future<ResearchResult> getResearch(
    String researchId,
  );
  Future<ResearchesResult> getResearches(
    List<String> researchIds, // a lista pode ser vazia, para todos os researchs, ou para filtrar por researchs do pesquisador
  );
  Future<ResearchResult> updateResearch(
    Research research,
  );
  Future<VoidResult> deleteResearch(
    String researchId,
  );
  Future<VoidResult> archiveResearch(
    String researchId,
  );
  Future<VoidResult> unarchiveResearch(
    String researchId,
  );
}

    

