import 'group_entity.dart';

class GroupMapper {
  
  static Map<String, String> toMap(Group group) {
    return {
      'name': group.name,
      
    };
  }

  static Group fromMap(Map<String, dynamic> map, String? documentId) {
  return Group(
    id: documentId ?? '',
    name: map['name'] as String,
  );
}
}
   
