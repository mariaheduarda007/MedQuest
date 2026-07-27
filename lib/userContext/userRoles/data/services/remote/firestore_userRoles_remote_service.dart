import 'package:cloud_firestore/cloud_firestore.dart';
import 'i_userRoles_remote_service.dart';
import 'dart:developer';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/userContext/userRoles/domain/models/userRole_model.dart';

class FirestoreUserRolesRemoteService implements IUserRolesRemoteService {
  final FirebaseFirestore _firestore;

  FirestoreUserRolesRemoteService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // deixei as verificações do path pq nao tenho certeza de como a app vai passar os ids

  // pegar todos os papéis desse user
  @override
  Future<Result<List<UserRoleModel>, Failure>> getUserRolesByUserId(
    String userId,
  ) async {
    try {
      final userPath = userId.startsWith('/') ? userId : '/User/$userId';

      final querySnapshot = await _firestore
          .collection('UserRole')
          .where('userId', isEqualTo: userPath)
          .get();

      final roles = querySnapshot.docs.map((doc) {
        return UserRoleModel.fromMap(doc.id, doc.data());
      }).toList();

      return Success(roles);
    } catch (e) {
      log(
        'Erro ao buscar roles do usuário: $e',
        name: 'Erro em buscar Roles do User',
      );
      return Error(DefaultFailure(e.toString()));
    }
  }

  //criar doc
  @override
  Future<VoidResult> createUserRole({
    required String userId,
    required String permissionId,
    String? researchId,
  }) async {
    try {
      final model = UserRoleModel(
        id: '',
        userId: userId.startsWith('/') ? userId : '/User/$userId',
        permissionId: permissionId.startsWith('/')
            ? permissionId
            : '/Permission/$permissionId',
        researchId: (researchId != null && researchId.isNotEmpty)
            ? (researchId.startsWith('/')
                  ? researchId
                  : '/Research/$researchId')
            : null,
      );

      await _firestore.collection('UserRole').add(model.toMap());

      return Success(null);
    } catch (e) {
      log('Erro ao criar UserRole: $e', name: 'Erro em criar Roles do User');
      return Error(DefaultFailure(e.toString()));
    }
  }

  //att doc
  @override
  Future<VoidResult> updateUserRole({
    required String userRoleId,
    String? permissionId,
    String? researchId,
  }) async {
    try {
      final Map<String, dynamic> updatedData = {};

      if (permissionId != null) {
        updatedData['permissionId'] = permissionId.startsWith('/')
            ? permissionId
            : '/Permission/$permissionId';
      }

      if (researchId != null) {
        updatedData['researchId'] = researchId.startsWith('/')
            ? researchId
            : '/Research/$researchId';
      }

      await _firestore
          .collection('UserRole')
          .doc(userRoleId)
          .update(updatedData);

      return Success(null);
    } catch (e) {
      log(
        'Erro ao atualizar UserRole: $e',
        name: 'Erro em atualizar Roles do User',
      );
      return Error(DefaultFailure(e.toString()));
    }
  }

  //deletar o doc inteiro
  @override
  Future<VoidResult> deleteUserRole(String userRoleId) async {
    try {
      await _firestore.collection('UserRole').doc(userRoleId).delete();
      return Success(null);
    } catch (e) {
      log(
        'Erro ao deletar UserRole: $e',
        name: 'Erro em deletar Roles do User',
      );
      return Error(DefaultFailure(e.toString()));
    }
  }

  // metodo extra que recebe todos ids de uma vez só pra deletar
  // @override
  // Future<VoidResult> deleteUserRole({
  //   required String userId,
  //   required String researchId,
  //   required String permissionId,
  // }) async {
  //   try {
  //     final formattedUserId = userId.startsWith('/') ? userId : '/User/$userId';
  //     final formattedResearchId = researchId.startsWith('/')
  //         ? researchId
  //         : '/Research/$researchId';
  //     final formattedPermissionId = permissionId.startsWith('/')
  //         ? permissionId
  //         : '/Permission/$permissionId';

  //     final querySnapshot = await _firestore
  //         .collection('UserRole')
  //         .where('userId', isEqualTo: formattedUserId)
  //         .where('researchId', isEqualTo: formattedResearchId)
  //         .where('permissionId', isEqualTo: formattedPermissionId)
  //         .get();

  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     return Success(null);
  //   } catch (e) {
  //     log('Erro ao deletar UserRole: $e', name: 'Erro ao deletar Roles do User');
  //     return Error(DefaultFailure(e.toString()));
  //   }
  // }
}
