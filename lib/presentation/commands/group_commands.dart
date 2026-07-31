import 'package:medquest/domain/facades/group_facade_usecases_interface.dart';
import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/type_defs.dart';
import '../../domain/models/group_entity.dart';

final class CreateGroupCommand
    extends ParameterizedCommand<Group, Failure, GroupParams> {
  final IGroupFacadeUseCases _groupFacadeUseCases;

  CreateGroupCommand(this._groupFacadeUseCases);

  @override
  Future<GroupResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar grupo.'));
    }

    return await _groupFacadeUseCases.createGroup(parameter!);
  }
}

final class GetGroupCommand
    extends ParameterizedCommand<Group, Failure, GroupIdParams> {
  final IGroupFacadeUseCases _groupFacadeUseCases;

  GetGroupCommand(this._groupFacadeUseCases);

  @override
  Future<GroupResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar grupo.'));
    }
    return await _groupFacadeUseCases.getGroup(parameter!);
  }
}

final class GetGroupsCommand
    extends ParameterizedCommand<List<Group>, Failure, ResearchIdParams> {
  final IGroupFacadeUseCases _groupFacadeUseCases;

  GetGroupsCommand(this._groupFacadeUseCases);

  @override
  Future<GroupsResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar grupos.'));
    }
    return await _groupFacadeUseCases.getGroups(parameter!);
  }
}

final class DeleteGroupCommand
    extends ParameterizedCommand<void, Failure, GroupIdParams> {
  final IGroupFacadeUseCases _groupFacadeUseCases;

  DeleteGroupCommand(this._groupFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir grupo.'));
    }
    return await _groupFacadeUseCases.deleteGroup(parameter!);
  }
}
