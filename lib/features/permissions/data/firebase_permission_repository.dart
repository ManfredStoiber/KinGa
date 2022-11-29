import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_student_repository.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/domain/permission_repository.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebasePermissionRepository implements PermissionRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;

  late String currentInstitutionId;
  Set<Student>? currentStudents;

  FirebasePermissionRepository() {
    currentInstitutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
  }

  @override
  Future<void> createPermission(String permission, Map<String, bool> studentPermissions) async {

    var studentService = GetIt.I<StudentService>();

    WriteBatch batch = db.batch();

    for (var studentId in studentPermissions.keys) {
      Student student = studentService.getStudent(studentId);
      if (studentPermissions[studentId]!) {
        student.permissions.add(permission);
      }

      DocumentReference doc = db.collection('Institution').doc(currentInstitutionId).collection('Student').doc( student.studentId);
      batch.set(doc, FirebaseUtils.studentToMap(student));

    }

    return batch.commit();

  }

  @override
  Future<void> deletePermission(String permission) async {

    WriteBatch batch = db.batch();

    for (var student in GetIt.I<StudentService>().students) {
      if (student.permissions.remove(permission)) {
        DocumentReference doc = db.collection('Institution').doc(currentInstitutionId).collection('Student').doc( student.studentId);
        batch.set(doc, FirebaseUtils.studentToMap(student));
      }
    }

    return batch.commit();

  }

}
