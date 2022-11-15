from django_grpc_framework import proto_serializers
import backend.models
import backend_pb2


class StudentProtoSerializer(proto_serializers.ModelProtoSerializer):
    class Meta:
        model = backend.Student
        proto_class = backend_pb2.Student
        fields = ['studentId', 'value']


class InstitutionProtoSerializer(proto_serializers.ModelProtoSerializer):
    class Meta:
        model = backend.Institution
        proto_class = backend_pb2.Institution
        fields = ['institutionId', 'students', 'encryptedInstitutionKey', 'institutionKeyIv',
                  'institutionName', 'passwordKeyNonce', 'verificationKey']
