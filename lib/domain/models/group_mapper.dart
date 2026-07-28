import 'group_entity.dart';

class GroupMapper {
  
  static Map<String, dynamic> toMap(Group group) {
    return {
      'id': group.id,
      'name': group.name,
      
    };
  }

  static Group fromMap(Map<String, dynamic> map) {
  return Group(
    id: map['id'] as String,
    name: map['name'] as String,
  );
}
}
   
