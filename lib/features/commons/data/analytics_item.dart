class AnalyticsItem {

  DateTime timestamp;
  String event;
  String? payload;

  AnalyticsItem(this.timestamp, this.event, {this.payload});

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'event': event,
      'payload': payload
    };
  }

  static AnalyticsItem fromMap(Map<String, dynamic> map) {
    return AnalyticsItem(DateTime.parse(map['timestamp']), map['event'], payload: map['payload']);
  }

}