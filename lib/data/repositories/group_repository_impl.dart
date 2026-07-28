import 'package:medquest/data/repositories/group_repository_interface.dart';
import 'package:medquest/data/services/group_firestore_interface.dart';
import 'package:medquest/domain/models/group_entity.dart';
import '../../core/typedefs/type_defs.dart';

/// implementação do repositório para Group

final class GroupRepositoryImpl implements IGroupRepository {
  final IGroupFirestore _firestore;

  GroupRepositoryImpl({required IGroupFirestore firestore})
    : _firestore = firestore;

  @override
  Future<GroupResult> createGroup(Group group, String researchId) {
    return _firestore.createGroup(group, researchId);
  }

  @override
  Future<GroupResult> getGroup(String researchId, String groupId) {
    return _firestore.getGroup(researchId, groupId);
  }

  @override
  Future<VoidResult> deleteGroup(String researchId, String groupId) {
    return _firestore.deleteGroup(researchId, groupId);
  }
}
