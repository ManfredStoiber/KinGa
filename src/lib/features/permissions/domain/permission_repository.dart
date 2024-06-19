abstract class PermissionRepository {

  /// Creates a new [permission]
  ///
  /// [studentPermissions] maps studentId to boolean value which states if student has [permission] or not
  Future<void> createPermission(String permission, Map<String, bool> studentPermissions);

  /// Deletes specified [permission]
  Future<void> deletePermission(String permission);
}
