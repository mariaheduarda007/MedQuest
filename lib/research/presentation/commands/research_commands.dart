import 'package:medquest/research/domain/facade/research_facade_usecases_interface.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../../core/patterns/result.dart';
import '../../../core/typedefs/type_defs.dart';

final class CreateResearchCommand
    extends ParameterizedCommand<Research, Failure, ResearchParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  CreateResearchCommand(this._researchFacadeUseCases);

  @override
  Future<ResearchResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar pesquisa.'));
    }

    return await _researchFacadeUseCases.createResearch(parameter!);
  }
}

final class GetResearchCommand
    extends ParameterizedCommand<Research, Failure, ResearchIdParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  GetResearchCommand(this._researchFacadeUseCases);

  @override
  Future<ResearchResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar pesquisa.'));
    }
    return await _researchFacadeUseCases.getResearch(parameter!);
  }
}

final class GetResearchesCommand
    extends ParameterizedCommand<List<Research>, Failure, ResearchesIdParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  GetResearchesCommand(this._researchFacadeUseCases);

  @override
  Future<ResearchesResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar pesquisas.'));
    }
    return await _researchFacadeUseCases.getResearches(parameter!);
  }
}

final class UpdateResearchCommand
    extends ParameterizedCommand<Research, Failure, ResearchParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  UpdateResearchCommand(this._researchFacadeUseCases);

  @override
  Future<ResearchResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar pesquisa.'));
    }
    return await _researchFacadeUseCases.updateResearch(parameter!);
  }
}

final class DeleteResearchCommand
    extends ParameterizedCommand<void, Failure, ResearchIdParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  DeleteResearchCommand(this._researchFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir pesquisa.'));
    }
    return await _researchFacadeUseCases.deleteResearch(parameter!);
  }
}

final class ArchiveResearchCommand
    extends ParameterizedCommand<void, Failure, ResearchIdParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  ArchiveResearchCommand(this._researchFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para arquivar pesquisa.'));
    }
    return await _researchFacadeUseCases.archiveResearch(parameter!);
  }
}

final class UnarchiveResearchCommand
    extends ParameterizedCommand<void, Failure, ResearchIdParams> {
  final IResearchFacadeUseCases _researchFacadeUseCases;

  UnarchiveResearchCommand(this._researchFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para desarquivar pesquisa.'));
    }
    return await _researchFacadeUseCases.unarchiveResearch(parameter!);
  }
}
