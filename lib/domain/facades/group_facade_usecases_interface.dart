import '../../core/typedefs/type_defs.dart';

abstract interface class IGroupFacadeUseCases {
  Future<GroupResult> createGroup(GroupParams params);
  Future<GroupResult> getGroup(GroupIdParams params);
  Future<GroupsResult> getGroups(ResearchIdParams params);
  Future<VoidResult> deleteGroup(GroupIdParams params);
}
