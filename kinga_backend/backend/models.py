from django.db import models


class Institution(models.Model):
    institutionId = models.CharField(max_length=5, primary_key=True)
    encryptedInstitutionKey = models.CharField(max_length=44)
    institutionKeyIv = models.CharField(max_length=24)
    institutionName = models.TextField()
    passwordKeyNonce = models.CharField(max_length=12)
    verificationKey = models.CharField(max_length=24)


class Student(models.Model):
    studentId = models.CharField(max_length=36, primary_key=True)
    value = models.TextField()
    institutionId = models.ForeignKey(Institution, on_delete=models.CASCADE)


class ProfileImage(models.Model):
    studentId = models.OneToOneField(Student, on_delete=models.CASCADE, primary_key=True)
    data = models.TextField()


