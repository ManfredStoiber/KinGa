import 'package:get_it/get_it.dart';
import 'package:kinga/features/permissions/domain/permission_repository.dart';

import '../../../domain/entity/student.dart';
import '../../../domain/student_service.dart';

class PostgresqlPermissionRepository implements PermissionRepository {

  @override
  Future<void> createPermission(String permission, Map<String, bool> studentPermissions) async {
    var studentService = GetIt.I<StudentService>();

    for (var studentId in studentPermissions.keys) {
      Student student = studentService.getStudent(studentId);
      if (studentPermissions[studentId]!) {
        student.permissions.add(permission);
      }

      await studentService.updateStudent(student);

    }
  }

  @override
  Future<void> deletePermission(String permission) async {
    var studentService = GetIt.I<StudentService>();
    for (var student in List.from(studentService.students)) { // List.from() to create shallow copy to prevent concurrent list modification
      if (student.permissions.remove(permission)) {
        await studentService.updateStudent(student);
      }
    }
    
  }

}
