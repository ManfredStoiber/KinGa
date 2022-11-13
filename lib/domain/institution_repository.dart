abstract class InstitutionRepository {
  Future<String?> createInstitution(String name, String institutionPassword);
  Future<void> joinInstitution(String institutionId, String institutionPassword);
  void leaveInstitution();
}