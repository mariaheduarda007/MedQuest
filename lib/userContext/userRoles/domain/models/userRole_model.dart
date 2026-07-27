import 'package:equatable/equatable.dart';

class UserRoleModel extends Equatable {
  final String id;
  final String userId;
  final String permissionId;
  final String? researchId;

  const UserRoleModel({
    required this.id,
    required this.userId,
    required this.permissionId,
    this.researchId,
  });

  @override
  List<Object?> get props => [id, userId, permissionId, researchId];

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'permissionId': permissionId,
    };
    if (researchId != null && researchId!.isNotEmpty) {
      map['researchId'] = researchId;
    }
    return map;
  }

  static UserRoleModel fromMap(String id, Map<String, dynamic> map) {
    return UserRoleModel(
      id: id,
      userId: map['userId'] ?? '',
      permissionId: map['permissionId'] ?? '',
      researchId: map['researchId'],
    );
  }
}