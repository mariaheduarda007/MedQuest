import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionCacheService {
  final FirebaseFirestore _firestore;

  // Mapa que guardará as permissões usando o nome do papel como chave:
  // Ex: { 'Coordinator': { 'createResearch': true, ... } }
  Map<String, Map<String, dynamic>>? _permissionsCache;

  PermissionCacheService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Busca todos os documentos da coleção Permission independentemente do ID aleatório
  Future<void> loadPermissions() async {
    if (_permissionsCache != null) return;

    try {
      final snapshot = await _firestore.collection('Permission').get();
      
      _permissionsCache = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        final roleName = data['roleName']; 

        if (roleName != null) {
          _permissionsCache![roleName] = data;
        }
      }
    } catch (e) {
      print('Erro ao carregar permissões: $e');
    }
  }

  /// Verifica a permissão usando o nome do papel (ex: 'Coordinator')
  bool hasPermission(String roleName, String permissionKey) {
    if (_permissionsCache == null) return false;

    final rolePermissions = _permissionsCache![roleName];
    if (rolePermissions == null) return false;

    return rolePermissions[permissionKey] == true;
  }
  Map<String, Map<String, dynamic>>? get allPermissions => _permissionsCache;
}