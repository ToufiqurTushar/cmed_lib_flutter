import 'package:age_calculator/age_calculator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:intl/intl.dart';

class CustomDateUtils {
  static const String DD_MMM_YYYY = 'dd MMM yyyy';
  static const String DD_MM_YYYY = 'dd MM yyyy';
  static const String DD__MM__YYYY = 'dd-MM-yyyy';
  static const String DD_MMM_YYYY_HH_MM_A = 'dd MMM yyyy, hh:mm a';
  static const String DD__MM__YYYY__HH_MM_A = 'dd-MM-yyyy, hh:mm a';
  static const String HH_MM_A_DD_MMM_YYYY = 'hh:mm a; dd MMM yyyy';
  static const String DD_MMM_YYYY_n_HH_MM_A = 'dd MMM yyyy,\n hh:mm a';
  static const String HH_MM_A_BRACKET = '(hh:mm a)';
  static const String HH_MM_A_NOBRACKET = 'hh:mm a';
  static const String HH_MM_A = 'hh:mm a';
  static const String MMM_YYYY = 'MMM yyyy';
  static const String EEEE = 'EEEE';
  static const String DD = 'dd';
  static const String DD_MMM = 'dd MMM';

  static String format(int? timeInMilliseconds,
      {String format = DD_MMM_YYYY, bool utc = false}) {
    if (timeInMilliseconds == null) return 'N/A';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    if (utc) {
      dateTime = dateTime.toUtc();
    }
    return DateFormat(format).format(dateTime);
  }

  static String formatDatePicker(String? timeInMilliseconds,
      {String format = DD_MMM_YYYY, bool utc = false}) {
    if (timeInMilliseconds == null) return 'N/A';
    var timeInMillisecondsInt = int.tryParse(timeInMilliseconds);
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeInMillisecondsInt ?? 0);
    if (utc) {
      dateTime = dateTime.toUtc();
    }
    return DateFormat(format).format(dateTime);
  }

  static int getEpochFromStringDate(String? date,
      {String inputFormat = DD_MMM_YYYY}) {
    if (date == null || date.isEmpty) return 0;
    return DateFormat(inputFormat).parse(date).millisecondsSinceEpoch;
  }

  static DateTime getDateTimeFromStringDate(String? date,
      {String inputFormat = DD_MMM_YYYY}) {
    if (date == null || date.isEmpty) return DateTime.now();
    return DateFormat(inputFormat).parse(date);
  }

  static DateTime getDateTimeFromEpoch(int timeInMilliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
  }

  static String getYearMonthDayFromLong(int? timeInMilliseconds) {
    if (timeInMilliseconds == null) return 'N/A';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);

    var age = "";
    "${AgeCalculator.age(dateTime).years}${'label_y'.tr} ${AgeCalculator.age(dateTime).months}${'label_m'.tr} ${AgeCalculator.age(dateTime).days}${'label_d'.tr}";

    if (AgeCalculator.age(dateTime).years > 0) {
      age += "${AgeCalculator.age(dateTime).years}${'label_y'.tr}";
    }
    if (AgeCalculator.age(dateTime).months > 0) {
      age += " ${AgeCalculator.age(dateTime).months}${'label_m'.tr}";
    }
    if (AgeCalculator.age(dateTime).days > 0 || age.isEmpty) {
      age += " ${AgeCalculator.age(dateTime).days}${'label_d'.tr}";
    }

    return age.trim();
  }

  static String getYearFromLong(int? timeInMilliseconds) {
    if (timeInMilliseconds == null) return 'N/A';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    return "${AgeCalculator.age(dateTime).years}";
  }

  static String getTodayTomorrowWeekDayFromTimeStamp(int? timeInMilliseconds,
      {bool utc = false}) {
    if (timeInMilliseconds == null) return 'N/A';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    if (utc) {
      dateTime = dateTime.toUtc();
    }

    if (AgeCalculator.age(dateTime).days == -1) {
      return "Tomorrow";
    } else if (AgeCalculator.age(dateTime).days == 0) {
      return "Today";
    } else if (AgeCalculator.age(dateTime).days == 1) {
      return "Yesterday";
    } else {
      return DateFormat(EEEE).format(dateTime);
    }
  }

  static openDatePicker(
    BuildContext context,
    Function onConfirm, {
    DateTime? maxDateTime,
    DateTime? minDateTime,
    DateTime? initialDateTime,
    Function? onDateChange,
  }) {
    return DatePicker.showDatePicker(context,
        pickerTheme: const DateTimePickerTheme(showTitle: true),
        onMonthChangeStartWithFirstDate: true,
        onClose: () => {
              debugPrint("onClose"),
            },
        onCancel: () => {
              debugPrint("onCancel"),
            },
        onConfirm: (DateTime dateTime, List<int> selectedIndex) => {
              onConfirm(dateTime),
              debugPrint("onConfirm$dateTime selectedIndex:$selectedIndex"),
            },
        onChange: (DateTime dateTime, List<int> selectedIndex) => {
              debugPrint("onChange$dateTime selectedIndex:$selectedIndex"),
            },
        minDateTime: minDateTime ?? DateTime(1910),
        maxDateTime: maxDateTime ?? DateTime.now(),
        initialDateTime: initialDateTime ?? DateTime.now(),
        pickerMode: DateTimePickerMode.date);
  }

  static String getFormattedDate(DateTime dateTime) {
    return formatDate(dateTime, [dd, ' ', M, ' ', yyyy]);
  }

  static DateTime getLastTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime getFirstTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getThisMonthsFirstDate() {
    return DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  }

  static DateTime getDateTimeSubtractedFromTimeByUnit(
      {String? unit, int time = 0}) {
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day - time);
    if (unit == "WEEK") {
      date = DateTime(now.year, now.month, now.day - time * 7);
    } else if (unit == "MONTH") {
      date = DateTime(now.year, now.month - time, now.day);
    } else if (unit == "YEAR") {
      date = DateTime(now.year - time, now.month - time, now.day);
    }
    return date;
  }

  static String getFormattedDateSubtractedFromTimeByUnit(
      {String? unit, int time = 0}) {
    DateTime date = getDateTimeSubtractedFromTimeByUnit(unit: unit, time: time);
    return CustomDateUtils.format(date.millisecondsSinceEpoch);
  }

  static String getRemainingTimeFromNow(DateTime endDate) {
    final now = DateTime.now();

    if (!endDate.isAfter(now)) {
      return '0 days';
    }

    int months = (endDate.year - now.year) * 12 + (endDate.month - now.month);

    int days = endDate.day - now.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(endDate.year, endDate.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) months = 0;

    if (months > 0) {
      return months == 1 ? '1 month' : '$months months';
    }

    if (days >= 7) {
      final weeks = (days / 7).ceil();
      return weeks == 1 ? '1 week' : '$weeks weeks';
    }

    return '$days days';
  }

  static String getYearOrMonthOrDayFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    int years = AgeCalculator.age(dateTime).years;
    int months = AgeCalculator.age(dateTime).months;
    int days = AgeCalculator.age(dateTime).days;
    if (years == 0) {
      if (months == 0) {
        if (days > 6 && days < 31) {
          return "${(days / 7).floor()} weeks";
        }
        return "$days days";
      }
      return "$months months";
    }
    return "$years years";
  }

  static String getYearOrMonthOrDayFromLong(int? timeInMilliseconds) {
    if (timeInMilliseconds == null) return 'N/A';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    return getYearOrMonthOrDayFromDateTime(dateTime);
  }

  static String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  static String formattedTimeInDayHourMinute({required int timeInSecond}) {
    int day = (timeInSecond / (24 * 3600)).toInt();

    timeInSecond = (timeInSecond % (24 * 3600)).toInt();
    int hour = (timeInSecond / 3600).toInt();

    timeInSecond = timeInSecond % 3600;

    int minutes = (timeInSecond / 60).toInt();

    timeInSecond = timeInSecond % 60;
    int seconds = timeInSecond;

    return '$day $hour:$minutes:$seconds';
  }

  static int calculateDifferenceInDayFromToday(dynamic date) {
    if (date is int) {
      date = DateTime.fromMillisecondsSinceEpoch(date);
    }
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String formatCurrentDateInBengaliAndEnglish() {
    DateTime now = DateTime.now();

    List<String> monthsEn = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    String day = now.day.toString();
    String month = monthsEn[now.month - 1].substring(0, 3);
    String year = now.year.toString();

    return '$month $day, $year';
  }

  static int getStartTimeOfCurrentMonth() {
    DateTime now = DateTime.now();

    // Get the first day of the current month
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    // Get milliseconds since epoch
    int milliseconds = firstDayOfMonth.millisecondsSinceEpoch;

    return milliseconds;
  }

  static int getStartTimeOfToday() {
    // Get current date
    DateTime now = DateTime.now();

    // Create a DateTime object for midnight (12:00 AM)
    DateTime midnight = DateTime(now.year, now.month, now.day, 23, 59);

    // Optionally, get milliseconds since epoch
    int milliseconds = midnight.millisecondsSinceEpoch;
    return milliseconds;
  }

  static int getVeryFirstTime() {
    return DateTime(2000).millisecondsSinceEpoch;
  }

  static int getEndTimeOfToday() {
    DateTime now = DateTime.now();

    // Create a DateTime object for the last moment of today (11:59:59 PM)
    DateTime lastTimeOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Optionally, get milliseconds since epoch
    int milliseconds = lastTimeOfToday.millisecondsSinceEpoch;
    return milliseconds;
  }
}
