import 'package:grpc/grpc.dart';
import 'package:kinga/generated/backend.pbgrpc.dart';


Future<void> main(List<String> args) async {
  final channel = ClientChannel(
    'localhost',
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = BackendClient(channel);
  try {
    var response = await stub.retrieveStudent(Student()..studentId = 'id'..value = 'value');
    print('Client received: ${response.studentId} ${response.value}');
  } catch (e) {
    print('Caught error: $e');
  }
  await channel.shutdown();
}