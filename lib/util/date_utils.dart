import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IsoDateUtils {
  static String getIsoDateFromIsoDateTime(String isoDateTime) {
    return isoDateTime.substring(0, 10);
  }

  static String getIsoTimeFromIsoDateTime(String isoDateTime) {
    return isoDateTime.substring(11, 16);
  }

  static DateTime getDateTimeFromIsoStrings(String date, String time) {
    return DateTime.parse('${date}T$time');
  }

  static String getIsoDateFromGermanDate(String germanDate) {
    final germanDateFormat = RegExp(r'\d\d.\d\d.\d\d\d\d');
    if (!germanDateFormat.hasMatch(germanDate)) {
      throw FormatException("Date $germanDate does not match german date format");
    }
    return "${germanDate.substring(6, 10)}-${germanDate.substring(3, 5)}-${germanDate.substring(0, 2)}";
  }

  static String getGermanDateFromDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  static String getGermanDateFromIsoDate(String isoDate) {
    return DateFormat('dd.MM.yyyy').format(DateTime.parse(isoDate));
  }

  static String getTimeFromTimeOfDay(TimeOfDay dateTime) {
    return "${_getFormattedTime(dateTime.hour)}:${_getFormattedTime(dateTime.minute)}";
  }

  static String _getFormattedTime(int time) {
    return time < 10 ? "0$time" : "$time";
  }

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }
}