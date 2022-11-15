from django.db import models


class Student(models.Model):
    studentId = models.CharField(max_length=100)
    value = models.CharField(max_length=100)


class Institution(models.Model):
    institutionId = models.CharField(max_length=100)
    students = models.SET(Student)
    encryptedInstitutionKey = models.CharField(max_length=100)
    institutionKeyIv = models.CharField(max_length=100)
    institutionName = models.CharField(max_length=100)
    passwordKeyNonce = models.CharField(max_length=100)
    verificationKey = models.CharField(max_length=100)


class ProfileImage(models.Model):
    studentId = models.CharField(max_length=100)

