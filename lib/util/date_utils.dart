class IsoDateUtils {
  static String getIsoDateFromIsoDateTime(String isoDateTime) {
    return isoDateTime.substring(0, 10);
  }

  static String getIsoTimeFromIsoDateTime(String isoDateTime) {
    return isoDateTime.substring(11, 16);
  }

  static DateTime getDateTimeFromIsoStrings(String date, String time) {
    return DateTime.parse('${date}T${time}');
  }

}