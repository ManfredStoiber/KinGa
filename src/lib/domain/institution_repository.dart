abstract class InstitutionRepository {
  Future<String?> createInstitution(String name, String institutionPassword);
  Future<String?> joinInstitution(String institutionId, String institutionPassword);
  void leaveInstitution();
}