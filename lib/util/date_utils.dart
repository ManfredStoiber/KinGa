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

  static String getIsoDateFromGermanDate(String germanDate) {
    final germanDateFormat = RegExp(r'\d\d.\d\d.\d\d\d\d');
    if (!germanDateFormat.hasMatch(germanDate)) {
      throw FormatException("Date ${germanDate} does not match german date format");
    }
    return "${germanDate.substring(6, 10)}-${germanDate.substring(3, 5)}-${germanDate.substring(0, 2)}";
  }
}