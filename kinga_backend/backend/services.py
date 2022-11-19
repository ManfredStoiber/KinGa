from django_grpc_framework import generics
from backend.models import Student
import backend_pb2
import backend_pb2_grpc


#class StudentService(generics.ModelService):
#    serializer_class = StudentProtoSerializer


class BackendServicer(backend_pb2_grpc.BackendServicer):
    def UpdateStudent(self, request, context):
        student = Student(studentId=request.studentId, value=request.value)
        student.save()
        return backend_pb2.Empty()

    def RetrieveStudent(self, request, context):
        student = Student.objects.get(studentId=request.studentId)
        result = {'studentId': student.studentId, 'value': student.value}
        return backend_pb2.Student(**result)

