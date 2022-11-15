from django_grpc_framework import generics

import backend_pb2
import backend_pb2_grpc


#class StudentService(generics.ModelService):
#    serializer_class = StudentProtoSerializer


class BackendServicer(backend_pb2_grpc.BackendServicer):
    def RetrieveStudent(self, request, context):
        result = {'studentId': request.studentId, 'value': request.value}
        return backend_pb2.Student(**result)

