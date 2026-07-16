// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:medquest/auth/domain/models/auth_entities.dart';

import 'package:medquest/userContext/user/domain/models/user_model.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart'; 
import 'i_user_remote_service.dart';

class FirestoreUserService implements IUserRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirestoreUserService() {
    print("LOG_CRÍTICO: FirestoreUserService foi instanciado!");
  }
  @override
  Future<VoidResult> saveUser(User user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      await _firestore
          .collection('User')
          .doc(uid)
          .set(UserModel(uid: user.uid, name: user.name, email: user.email).toMap());
      return Success(null);
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<UserResult> getUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      final doc = await _firestore.collection('User').doc(uid).get();
      if (doc.exists) {
        return Success(UserModel.fromMap(doc.data()!));
      }
      return Error(DefaultFailure("Usuário não encontrado"));
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<VoidResult> deleteUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      await _firestore.collection('User').doc(uid).delete();

      return Success(null);
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<VoidResult> updateUser(User user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final data = UserModel(uid: user.uid, name: user.name, email: user.email).toMap();
      // ignore: avoid_print
      print("DOC_ID_ALVO: $uid");
      // ignore: avoid_print
      print("DADOS_ENVIADOS: $data");
      final docSnapshot = await _firestore
          .collection('User')
          .doc(uid)
          .get();
      // ignore: avoid_print
      print("O DOCUMENTO EXISTE NO BANCO? ${docSnapshot.exists}");

      await _firestore.collection('User').doc(uid).update(data);

      return Success(null);
    } catch (e) {
      print("DEBUG: Erro no update: $e");
      return Error(DefaultFailure(e.toString()));
    }
  }
}
