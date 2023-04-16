from django_grpc_framework import proto_serializers
import backend.models as backend
import backend_pb2 as proto


class StudentProtoSerializer(proto_serializers.ModelProtoSerializer):
    class Meta:
        model = backend.Student
        proto_class = proto.Student
        fields = '__all__'


class InstitutionProtoSerializer(proto_serializers.ModelProtoSerializer):
    class Meta:
        model = backend.Institution
        proto_class = proto.Institution
        fields = '__all__'


class ProfileImageProtoSerializer(proto_serializers.ModelProtoSerializer):
    class Meta:
        model = backend.ProfileImage
        proto_class = proto.ProfileImage
        fields = '__all__'
