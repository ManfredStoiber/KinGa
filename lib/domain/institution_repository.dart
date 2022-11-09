import 'dart:typed_data';

abstract class InstitutionRepository {
  Future<bool> createInstitution(String institutionId, String name, String institutionPassword);
  Future<void> joinInstitution(String institutionId, String institutionPassword);
  void leaveInstitution();
  Future<String> generateInstitutionId();
}