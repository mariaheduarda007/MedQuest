import 'package:medquest/research/domain/facade/research_facade_usecases_interface.dart';
import '../../../core/typedefs/type_defs.dart';
import '../usecases/research_usecases_interface.dart';

final class ResearchFacadeUsecasesImpl implements IResearchFacadeUseCases {
  final ICreateResearchUseCase _createResearchUseCase;
  final IGetResearchUseCase _getResearchUseCase;
  final IGetResearchesUseCase _getResearchesUseCase;
  final IUpdateResearchUseCase _updateResearchUseCase;
  final IDeleteResearchUseCase _deleteResearchUseCase;
  final IArchiveResearchUseCase _archiveResearchUseCase;
  final IUnarchiveResearchUseCase _unarchiveResearchUseCase;
  final IExportResearchToExcelUseCase _exportResearchToExcelUseCase;
  final IGetScoreChartDataUseCase _getScoreChartDataUseCase;
  ResearchFacadeUsecasesImpl({
    required ICreateResearchUseCase createResearchUseCase,
    required IGetResearchUseCase getResearchUseCase,
    required IGetResearchesUseCase getResearchesUseCase,
    required IUpdateResearchUseCase updateResearchUseCase,
    required IDeleteResearchUseCase deleteResearchUseCase,
    required IArchiveResearchUseCase archiveResearchUseCase,
    required IUnarchiveResearchUseCase unarchiveResearchUseCase,
    required IExportResearchToExcelUseCase exportResearchToExcelUseCase,
    required IGetScoreChartDataUseCase getScoreChartDataUseCase,
  }) : _createResearchUseCase = createResearchUseCase,
       _getResearchUseCase = getResearchUseCase,
       _getResearchesUseCase = getResearchesUseCase,
       _updateResearchUseCase = updateResearchUseCase,
       _deleteResearchUseCase = deleteResearchUseCase,
       _archiveResearchUseCase = archiveResearchUseCase,
       _unarchiveResearchUseCase = unarchiveResearchUseCase,
      _exportResearchToExcelUseCase = exportResearchToExcelUseCase,
      _getScoreChartDataUseCase = getScoreChartDataUseCase;

  @override
  Future<ResearchResult> createResearch(ResearchParams params) {
    return _createResearchUseCase(params);
  }

  @override
  Future<ResearchResult> getResearch(ResearchIdParams params) {
    return _getResearchUseCase(params);
  }

  @override
  Future<ResearchesResult> getResearches(ResearchesIdParams params) {
    return _getResearchesUseCase(params);
  }

  @override
  Future<ResearchResult> updateResearch(ResearchParams params) {
    return _updateResearchUseCase(params);
  }

  @override
  Future<VoidResult> deleteResearch(ResearchIdParams params) {
    return _deleteResearchUseCase(params);
  }

  @override
  Future<VoidResult> archiveResearch(ResearchIdParams params) {
    return _archiveResearchUseCase(params);
  }

  @override
  Future<VoidResult> unarchiveResearch(ResearchIdParams params) {
    return _unarchiveResearchUseCase(params);
  }

  @override
  Future<VoidResult> exportResearchToExcel(ResearchIdParams params) {
    return _exportResearchToExcelUseCase(params);
  }

  @override
  Future<ChartDataResult> getScoreChartData(ResearchIdParams params) {
    return _getScoreChartDataUseCase(params);
  }
}
