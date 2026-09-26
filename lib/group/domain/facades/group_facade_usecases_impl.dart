import 'package:medquest/group/domain/facades/group_facade_usecases_interface.dart';
import '../../../core/typedefs/type_defs.dart';
import '../usecases/group_usecases_interface.dart';

final class GroupFacadeUsecasesImpl implements IGroupFacadeUseCases {
  final ICreateGroupUseCase _createGroupUseCase;
  final IGetGroupUseCase _getGroupUseCase;
  final IGetGroupsUseCase _getGroupsUseCase;
  final IDeleteGroupUseCase _deleteGroupUseCase;

  GroupFacadeUsecasesImpl({
    required ICreateGroupUseCase createGroupUseCase,
    required IGetGroupUseCase getGroupUseCase,
    required IGetGroupsUseCase getGroupsUseCase,
    required IDeleteGroupUseCase deleteGroupUseCase,
  }) : _getGroupUseCase = getGroupUseCase,
       _getGroupsUseCase = getGroupsUseCase,
       _createGroupUseCase = createGroupUseCase,
       _deleteGroupUseCase = deleteGroupUseCase;

  @override
  Future<GroupResult> createGroup(GroupParams params) {
    return _createGroupUseCase(params);
  }

  @override
  Future<GroupResult> getGroup(GroupIdParams params) {
    return _getGroupUseCase(params);
  }

  @override
  Future<GroupsResult> getGroups(ResearchIdParams params) {
    return _getGroupsUseCase(params);
  }

  @override
  Future<VoidResult> deleteGroup(GroupIdParams params) {
    return _deleteGroupUseCase(params);
  }
}
