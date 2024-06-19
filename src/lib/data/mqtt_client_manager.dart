
import 'dart:io';

import 'package:kinga/constants/backend_config.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttClientManager {

  var logger = Logger();

  String clientId = 'flutter_client_${const Uuid().v1()}';
  late MqttServerClient mqttServerClient;

  MqttClientManager() {
    mqttServerClient = MqttServerClient(BackendConfig.mqttHost, clientId);
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
    mqttServerClient.connectionMessage = connMess;

    try {
      await mqttServerClient.connect();
    } on NoConnectionException catch (e) {
      logger.e('Client exception: $e');
      mqttServerClient.disconnect();
    } on SocketException catch (e) {
      logger.e('Socket exception: $e');
      mqttServerClient.disconnect();
    }

    if (mqttServerClient.connectionStatus!.state == MqttConnectionState.connected) {
    } else {
      logger.e('Client connection failed - disconnecting, status is ${mqttServerClient.connectionStatus}');
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
    logger.v('Subscription confirmed for topic $topic');
  }

  void onUnsubscribed(String topic) {
    logger.v('Unsubscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    logger.e('Failed to subscribe $topic');
  }

  void onDisconnected() {
    logger.i('OnDisconnected client callback - Client disconnection');
  }

  void onConnected() {
    logger.i('OnConnected client callback - Client connection was successful');
  }

  void pong() {
    logger.i('Ping response client callback invoked');
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return mqttServerClient.updates;
  }
}