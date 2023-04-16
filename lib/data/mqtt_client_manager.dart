
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttClientManager {
  String clientId = 'flutter_client_${const Uuid().v1()}';
  late MqttServerClient mqttServerClient;

  MqttClientManager() {
    mqttServerClient = MqttServerClient('test.mosquitto.org', clientId);
  }

  Future<int> connect() async {
    mqttServerClient.logging(on: true);
    mqttServerClient.keepAlivePeriod = 60;
    mqttServerClient.onDisconnected = onDisconnected;
    mqttServerClient.onConnected = onConnected;
    mqttServerClient.onSubscribed = onSubscribed;
    mqttServerClient.onSubscribeFail = onSubscribeFail;
    mqttServerClient.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Client connecting....');
    mqttServerClient.connectionMessage = connMess;

    try {
      await mqttServerClient.connect();
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      mqttServerClient.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      mqttServerClient.disconnect();
    }

    if (mqttServerClient.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print('Client connection failed - disconnecting, status is ${mqttServerClient.connectionStatus}');
      mqttServerClient.disconnect();
      exit(-1);
    }

    return 0;
  }

  void disconnect() {
    mqttServerClient.disconnect();
  }

  void subscribe(String topic) {
    mqttServerClient.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
  }

  void onConnected() {
    print('OnConnected client callback - Client connection was successful');
  }

  void pong() {
    print('Ping response client callback invoked');
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return mqttServerClient.updates;
  }
}