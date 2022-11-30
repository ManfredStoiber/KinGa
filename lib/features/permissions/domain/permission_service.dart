import 'package:get_it/get_it.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/domain/permission_repository.dart';

class PermissionService {

  final StudentService _studentService = GetIt.I<StudentService>();
  final PermissionRepository _permissionRepository = GetIt.I<PermissionRepository>();

  List<String> getPermissions() {
    Set<String> permissions = {};
    for (var student in _studentService.students) {
      permissions.addAll(student.permissions);
    }
    return permissions.toList()..sort();
  }

  Future<void> createPermission(String permission, Map<String, bool> studentPermissions) async {
    return _permissionRepository.createPermission(permission, studentPermissions);
  }

  Future<void> deletePermission(String permission) async {
    return _permissionRepository.deletePermission(permission);
  }

}