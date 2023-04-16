from typing import Iterable

import grpc
from backend.models import Student, Institution, ProfileImage
import backend_pb2
import backend_pb2_grpc
import backend.mqtt_client as mqtt_client

from backend.serializers import StudentProtoSerializer, InstitutionProtoSerializer, ProfileImageProtoSerializer


class BackendServicer(backend_pb2_grpc.BackendServicer):
    def CreateStudent(self, request, context):
        print('Create student: ' + request.studentId)
        serializer = StudentProtoSerializer(message=request)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        self.publish_msg('Create student')
        return serializer.message

    def DeleteStudent(self, request, context):
        print('Delete student: ' + request.requestId)
        student = self.get_student(request.requestId)
        student.delete()
        self.publish_msg('Delete student')
        return backend_pb2.Empty()

    def UpdateStudent(self, request, context):
        print('Update student: ' + request.studentId)
        student = self.get_student(request.studentId)
        serializer = StudentProtoSerializer(student, message=request)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        self.publish_msg('Update student')
        return serializer.message

    def RetrieveStudent(self, request, context):
        print('Retrieve student: ' + request.requestId)
        student = self.get_student(request.requestId)
        serializer = StudentProtoSerializer(student)
        return serializer.message

    def RetrieveInstitutionStudents(self, request, context) -> Iterable[backend_pb2.Student]:
        print('Retrieve students for institution: ' + request.requestId)
        try:
            students = Student.objects.filter(institutionId=request.requestId)
            for student in students:
                serializer = StudentProtoSerializer(student)
                yield serializer.message
        except Student.DoesNotExist:
            self.context.abort(grpc.StatusCode.NOT_FOUND, 'Students for institution: %s not found!' % request.requestId)

    def get_student(self, student_id):
        try:
            return Student.objects.get(studentId=student_id)
        except Student.DoesNotExist:
            self.context.abort(grpc.StatusCode.NOT_FOUND, 'Student: %s not found!' % student_id)

    def CreateInstitution(self, request, context):
        print('Create institution: ' + request.institutionId)
        serializer = InstitutionProtoSerializer(message=request)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return serializer.message

    def RetrieveInstitution(self, request, context):
        print('Retrieve institution: ' + request.requestId)
        institution = self.get_institution(request.requestId)
        serializer = InstitutionProtoSerializer(institution)
        return serializer.message

    def get_institution(self, institution_id):
        try:
            return Institution.objects.get(institutionId=institution_id)
        except Institution.DoesNotExist:
            self.context.abort(grpc.StatusCode.NOT_FOUND, 'Institution: %s not found!' % institution_id)

    def CreateProfileImage(self, request, context):
        print('Create profile image for student: ' + request.studentId)
        serializer = ProfileImageProtoSerializer(message=request)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        self.publish_msg('Create profile image')
        return serializer.message

    def UpdateProfileImage(self, request, context):
        print('Update profile image for student: ' + request.studentId)
        profile_image = self.get_profile_image(request.studentId)
        serializer = ProfileImageProtoSerializer(profile_image, message=request)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        self.publish_msg('Update profile image')
        return serializer.message

    def RetrieveProfileImage(self, request, context):
        print('Retrieve profile image for student: ' + request.requestId)
        profile_image = self.get_profile_image(request.requestId)
        serializer = ProfileImageProtoSerializer(profile_image)
        return serializer.message

    def get_profile_image(self, student_id):
        try:
            return ProfileImage.objects.get(studentId=student_id)
        except ProfileImage.DoesNotExist:
            self.context.abort(grpc.StatusCode.NOT_FOUND, 'Profile image for student: %s not found!' % student_id)

    def publish_msg(self, msg):
        client = mqtt_client.connect_mqtt()
        mqtt_client.publish(client, msg)
