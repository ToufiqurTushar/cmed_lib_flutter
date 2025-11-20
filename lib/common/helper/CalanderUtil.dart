import 'dart:core';
import 'dart:ui';

class CalendarUtil {
  static final CalendarUtil instance = CalendarUtil._internal();

  factory CalendarUtil() {
    return instance;
  }

  CalendarUtil._internal();

  DateTime get currentDateTime => DateTime.now();

  int get currentDay => currentDateTime.day;

  int get currentMonth => currentDateTime.month;

  int get currentYear => currentDateTime.year;

  String get currentMonthDay =>
      '${currentMonth}-${currentDay}';

  // String get currentDateFormatted =>
  //     formatDate(currentDateTime, DATE_FORMAT);
  //
  // String get currentTimeFormatted =>
  //     formatTime(currentDateTime, TIME_FORMAT);

  String get currentTimeStamp =>
      formatDateTime(currentDateTime, TIMESTAMP_FORMAT);

  String get currentDateStamp =>
      formatDateTime(currentDateTime, DATESTAMP_FORMAT);

  String get todayDateStamp =>
      formatDateTime(currentDateTime, TODAY_STAMP_FORMAT);

  String getFormattedDateTime(String outputFormat) =>
      formatDateTime(currentDateTime, outputFormat);

  String getFormattedDateTimeWithLocale(String outputFormat, Locale locale) {
    return formatDateTime(currentDateTime, outputFormat);
  }

  String getDateFromTimeStamp(String inputDate, String inputFormat, String outputFormat) {
    DateTime parsedDate = parseDate(inputDate, inputFormat);
    return formatDateTime(parsedDate, outputFormat);
  }

  String getConvertedDate(String date, String inputFormat, String outputFormat) {
    DateTime parsedDate = parseDate(date, inputFormat);
    return formatDateTime(parsedDate, outputFormat);
  }

  List<int> getConvertedYearMonthDay(String date, String dateFormat) {
    if (dateFormat == DATESTAMP_FORMAT || dateFormat == TODAY_STAMP_FORMAT) {
      List<String> dateList = date.split(RegExp(r'[-/]'));
      try {
        return [int.parse(dateList[0]), int.parse(dateList[1]), int.parse(dateList[2])];
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  int getAgeFromTimeInMillis(int? timeInMillis) {
    if (timeInMillis == null) return 0;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    DateTime now = DateTime.now();
    return (now.year - birthDate.year) - (now.isBefore(DateTime(now.year, birthDate.month, birthDate.day)) ? 1 : 0);
  }

  int getAgeFromTimeInMillisInMonth(int? timeInMillis) {
    if (timeInMillis == null) return 0;
    DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    DateTime now = DateTime.now();
    return ((now.year - birthDate.year) * 12 + now.month - birthDate.month);
  }

  String getDateFromTimeInMillis(int? timeInMillis, {String? format}) {
    if (timeInMillis == null) return '';
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    return formatDateTime(date, format ?? DATESTAMP_FORMAT);
  }

  int? getTimeInMillisFromDate(String? date, String dateFormat, {bool isEndDate = false}) {
    try {
      DateTime parsedDate = parseDate(date!, dateFormat);
      return parsedDate.millisecondsSinceEpoch + (isEndDate ? ALMOST_ONE_DAY : 0);
    } catch (e) {
      return null;
    }
  }

  List<int>? getFirstAndLastDateOfMonthInMillisFromDate(String? date, String format) {
    try {
      DateTime parsedDate = parseDate(date!, format);
      DateTime firstDay = DateTime(parsedDate.year, parsedDate.month, 1);
      DateTime lastDay = DateTime(parsedDate.year, parsedDate.month + 1, 0); // Last day of the month
      return [firstDay.millisecondsSinceEpoch, lastDay.millisecondsSinceEpoch + ALMOST_ONE_DAY];
    } catch (e) {
      return null;
    }
  }

  List<int>? getFirstAndLastDateOfDayInMillisFromDate(String? date, String format) {
    try {
      DateTime parsedDate = parseDate(date!, format);
      DateTime startOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      DateTime endOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day + 1).subtract(Duration(milliseconds: 1));
      return [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch];
    } catch (e) {
      return null;
    }
  }

  String getFullAgeString(DateTime birthDate) {
    List<String> ageParts = getAgeFromGivenBirthDate(birthDate);
    StringBuffer stringBuffer = StringBuffer();

    int years = int.parse(ageParts[0]);
    int months = int.parse(ageParts[1]);
    int days = int.parse(ageParts[2]);

    if (years > 0) stringBuffer.write('${years}Y');
    if (months > 0) stringBuffer.write(' ${months}M');
    if (days > 0) stringBuffer.write(' ${days}D');

    return stringBuffer.toString().trim();
  }

  List<int>? getFirstAndLastDateOfMonthInMillis(int? timeInMillis) {
    try {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timeInMillis ?? DateTime.now().millisecondsSinceEpoch);
      DateTime firstDay = DateTime(date.year, date.month, 1);
      DateTime lastDay = DateTime(date.year, date.month + 1, 0);
      return [firstDay.millisecondsSinceEpoch, lastDay.millisecondsSinceEpoch + ALMOST_ONE_DAY];
    } catch (e) {
      return null;
    }
  }

  List<String> getAgeFromGivenBirthDate(DateTime givenDate) {
    DateTime currentDate = DateTime.now();
    int years = currentDate.year - givenDate.year;
    int months = currentDate.month - givenDate.month;
    int days = currentDate.day - givenDate.day;

    if (days < 0) {
      days += DateTime(currentDate.year, currentDate.month, 0).day; // Last day of previous month
      months--;
    }
    if (months < 0) {
      months += 12;
      years--;
    }
    return [years.toString(), months.toString(), days.toString()];
  }

  String getAgeString(DateTime calendar) {
    List<String> age = getAgeFromGivenBirthDate(calendar);
    StringBuffer stringBuffer = StringBuffer();

    int years = int.parse(age[0]);
    int months = int.parse(age[1]);
    int days = int.parse(age[2]);

    if (years > 0) stringBuffer.write('$years ${years == 1 ? "year" : "years"} ');
    if (months > 0) stringBuffer.write('$months ${months == 1 ? "month" : "months"} ');
    if (years <= 0 && days > 0) stringBuffer.write('$days ${days == 1 ? "day" : "days"} ');

    return stringBuffer.toString().trim();
  }

  List<int>? getFirstAndLastTimeOfToday() {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
      return [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch];
    } catch (e) {
      return null;
    }
  }

  String getElapsedTimeString(int? fromTime, [int? toTime]) {
    if (fromTime == null) return '';
    DateTime fromDate = DateTime.fromMillisecondsSinceEpoch(fromTime);
    DateTime toDate = DateTime.now();
    if (toTime != null) {
      toDate = DateTime.fromMillisecondsSinceEpoch(toTime);
    }

    Duration difference = toDate.difference(fromDate);
    StringBuffer stringBuffer = StringBuffer();

    int years = difference.inDays ~/ 365;
    int months = (difference.inDays % 365) ~/ 30;
    int days = (difference.inDays % 365) % 30;

    if (years > 0) stringBuffer.write('$years ${years == 1 ? "year" : "years"} ');
    if (years > 0 && months > 0) stringBuffer.write('and $months ${months == 1 ? "month" : "months"} ');
    if (years <= 0 && months > 0) stringBuffer.write('$months ${months == 1 ? "month" : "months"} ');
    if (years <= 0 && days > 0 && months <= 0) {
      if (days % 7 == 0) {
        int weeks = days ~/ 7;
        stringBuffer.write('$weeks ${weeks == 1 ? "week" : "weeks"} ');
      } else {
        stringBuffer.write('$days ${days == 1 ? "day" : "days"} ');
      }
    }

    return stringBuffer.toString().trim();
  }

  List<String> getTimeDifferenceString(DateTime fromDate, DateTime toDate) {
    int currentDay = toDate.day;
    int currentMonth = toDate.month;
    int currentYear = toDate.year;
    int givenDay = fromDate.day;
    int givenMonth = fromDate.month;
    int givenYear = fromDate.year;

    int requiredMonth;
    int requiredDay;

    if (givenDay > currentDay) {
      requiredDay = currentDay + 30 - givenDay;
      givenMonth++;
    } else {
      requiredDay = currentDay - givenDay;
    }

    if (givenMonth > currentMonth) {
      requiredMonth = currentMonth + 12 - givenMonth;
      givenYear++;
    } else {
      requiredMonth = currentMonth - givenMonth;
    }

    int requiredYear = currentYear - givenYear;

    return [requiredYear.toString(), requiredMonth.toString(), requiredDay.toString()];
  }

  String formatDateTime(DateTime dateTime, String format) {
    return dateTime.toString();
  }

  DateTime parseDate(String date, String format) {
    return DateTime.parse(date);
  }
}


const String DATE_FORMAT = 'yyyy-MM-dd';
const String TIME_FORMAT = 'HH:mm:ss';
const String TIMESTAMP_FORMAT = 'yyyy-MM-dd HH:mm:ss';
const String DATESTAMP_FORMAT = 'yyyy-MM-dd';
const String TODAY_STAMP_FORMAT = 'yyyy-MM-dd';
const int ALMOST_ONE_DAY = 86400000;
