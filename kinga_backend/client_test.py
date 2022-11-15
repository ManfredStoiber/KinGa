import grpc
import backend_pb2
import backend_pb2_grpc


class UnaryClient(object):
    def __init__(self):
        self.host = 'localhost'
        self.server_port = 50051

        # instantiate a channel
        self.channel = grpc.insecure_channel(
            '{}:{}'.format(self.host, self.server_port))

        # bind the client and the server
        self.stub = backend_pb2_grpc.BackendStub(self.channel)

    def get_url(self, student):
        result = backend_pb2.Student(studentId=student.studentId, value=student.value)
        return self.stub.RetrieveStudent(result)


if __name__ == '__main__':
    client = UnaryClient()
    result = client.get_url(student=backend_pb2.Student(studentId='id', value='value'))
    print(f'{result}')
