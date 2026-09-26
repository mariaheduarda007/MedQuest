import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/group_entity.dart';

abstract interface class IGroupRepository {
  Future<GroupResult> createGroup(
    Group group,
    String researchId,
  );
  Future<GroupResult> getGroup(
    String researchId,
    String groupId,
  );
   Future<GroupsResult> getGroups(
    String researchId
  );
  Future<VoidResult> deleteGroup(
    String researchId,
    String groupId,
  );
}
