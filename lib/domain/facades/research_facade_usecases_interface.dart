import '../../core/typedefs/type_defs.dart';

abstract interface class IResearchFacadeUseCases {
  Future<ResearchResult> createResearch(ResearchParams params);
  Future<ResearchResult> getResearch(ResearchIdParams params);
  Future<ResearchesResult> getResearches(ResearchesIdParams params);
  Future<ResearchResult> updateResearch(ResearchParams params);
  Future<VoidResult> deleteResearch(ResearchIdParams params);
  Future<VoidResult> archiveResearch(ResearchIdParams params);
  Future<VoidResult> unarchiveResearch(ResearchIdParams params);
}
