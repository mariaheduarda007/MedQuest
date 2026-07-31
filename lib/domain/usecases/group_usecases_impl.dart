import '../../core/typedefs/type_defs.dart';
import '../../data/repositories/group_repository_interface.dart';
import 'group_usecases_interface.dart';

final class CreateGroupUseCaseImpl implements ICreateGroupUseCase {
  final IGroupRepository _repository;

  CreateGroupUseCaseImpl({required IGroupRepository repository})
    : _repository = repository;

  @override
  Future<GroupResult> call(GroupParams params) async {
    return _repository.createGroup(params.group, params.researchId);
  }
}

final class GetGroupUseCaseImpl implements IGetGroupUseCase {
  final IGroupRepository _repository;

  GetGroupUseCaseImpl({required IGroupRepository repository})
    : _repository = repository;

  @override
  Future<GroupResult> call(GroupIdParams params) async {
    return _repository.getGroup(params.researchId, params.groupId);
  }
}

final class GetGroupsUseCaseImpl implements IGetGroupsUseCase {
  final IGroupRepository _repository;

  GetGroupsUseCaseImpl({required IGroupRepository repository})
    : _repository = repository;

  @override
  Future<GroupsResult> call(ResearchIdParams params) async {
    return _repository.getGroups(params.researchId);
  }
}

final class DeleteGroupUseCaseImpl implements IDeleteGroupUseCase {
  final IGroupRepository _repository;

  DeleteGroupUseCaseImpl({required IGroupRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(GroupIdParams params) async {
    return _repository.deleteGroup(params.researchId, params.groupId);
  }
}
