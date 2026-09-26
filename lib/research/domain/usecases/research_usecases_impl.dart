import 'package:medquest/research/data/repository/research_repository.dart';
import 'package:medquest/research/domain/usecases/research_usecases_interface.dart';
import '../../../core/typedefs/type_defs.dart';


final class CreateResearchUseCaseImpl implements ICreateResearchUseCase {
  final IResearchRepository _repository;

  CreateResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<ResearchResult> call(ResearchParams params) async {
    return _repository.createResearch(
      params.research,
    );
  }
}

final class GetResearchUseCaseImpl implements IGetResearchUseCase {
  final IResearchRepository _repository;

  GetResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<ResearchResult> call(ResearchIdParams params) async {
    return _repository.getResearch(
      params.researchId,
    );
  }
}


final class GetResearchesUseCaseImpl implements IGetResearchesUseCase {
  final IResearchRepository _repository;

  GetResearchesUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<ResearchesResult> call(ResearchesIdParams params) async {
    return _repository.getResearches(
      params.researchesId,
    );
  }
}


final class UpdateResearchUseCaseImpl implements IUpdateResearchUseCase {
  final IResearchRepository _repository;

  UpdateResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<ResearchResult> call(ResearchParams params) async {
    return _repository.updateResearch(
      params.research,
    );
  }
}


final class DeleteResearchUseCaseImpl implements IDeleteResearchUseCase {
  final IResearchRepository _repository;

  DeleteResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(ResearchIdParams params) async {
    return _repository.deleteResearch(
      params.researchId,
    );
  }
}

final class ArchiveResearchUseCaseImpl implements IArchiveResearchUseCase {
  final IResearchRepository _repository;

  ArchiveResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(ResearchIdParams params) async {
    return _repository.archiveResearch(
      params.researchId,
    );
  }
}

final class UnarchiveResearchUseCaseImpl implements IUnarchiveResearchUseCase {
  final IResearchRepository _repository;

  UnarchiveResearchUseCaseImpl({required IResearchRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(ResearchIdParams params) async {
    return _repository.unarchiveResearch(
      params.researchId,
    );
  }
}
