
class BackendConfig {
  static const String backendServerHost = 'kinga-online.de';
  //static const String backendServerHost = '192.168.2.140';
  static const String identityProviderHost = 'kinga-online.de';
  static const String mqttHost = 'kinga-online.de';
  static const int port = 50051;
  static const String discoveryUrl = 'https://$identityProviderHost:8443/realms/kinga/.well-known/openid-configuration';
}