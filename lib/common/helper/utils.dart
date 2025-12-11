import 'dart:collection';
import 'dart:io';
import 'package:cmed_lib_flutter/common/common_key.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get_storage/get_storage.dart';

enum PlatformNameEnum { ANDROID, IOS}
class Utils{

  static String? getPlatformName() {
    if(Platform.isAndroid) {
      return PlatformNameEnum.ANDROID.name;
    } else if(Platform.isIOS) {
      return PlatformNameEnum.IOS.name;
    } else {
      return null;
    }
  }

  static String? getDateBanglaFromEnglish(String? date) {
    if(!isLocaleBn()) return date??'';
    date = date?.trAmount();
    var englishToBanglaDigitsMap = HashMap<String, String>();
    englishToBanglaDigitsMap["Jan"] = "জানু.";
    englishToBanglaDigitsMap["Feb"] = "ফেব্রু.";
    englishToBanglaDigitsMap["Mar"] = "মার্চ";
    englishToBanglaDigitsMap["Apr"] = "এপ্রি.";
    englishToBanglaDigitsMap["May"] = "মে";
    englishToBanglaDigitsMap["Jun"] = "জুন";
    englishToBanglaDigitsMap["Jul"] = "জুলা.";
    englishToBanglaDigitsMap["Aug"] = "আগস্.";
    englishToBanglaDigitsMap["Sep"] = "সেপ্টে.";
    englishToBanglaDigitsMap["Oct"] = "অক্টো.";
    englishToBanglaDigitsMap["Nov"] = "নভে.";
    englishToBanglaDigitsMap["Dec"] = "ডিসে.";

    englishToBanglaDigitsMap.forEach((engMonth, bnMonth){
      date = date?.replaceAll(engMonth, bnMonth);
    });

    return date;
  }

  static String getDigitBanglaFromEnglish(String? number) {
    if(!isLocaleBn()) return number??'';
    var englishToBanglaDigitsMap = HashMap<String, String>();
    englishToBanglaDigitsMap["0"] = "০";
    englishToBanglaDigitsMap["1"] = "১";
    englishToBanglaDigitsMap["2"] = "২";
    englishToBanglaDigitsMap["3"] = "৩";
    englishToBanglaDigitsMap["4"] = "৪";
    englishToBanglaDigitsMap["5"] = "৫";
    englishToBanglaDigitsMap["6"] = "৬";
    englishToBanglaDigitsMap["7"] = "৭";
    englishToBanglaDigitsMap["8"] = "৮";
    englishToBanglaDigitsMap["9"] = "৯";

    englishToBanglaDigitsMap.forEach((key, value){
      number = number?.replaceAll(key, value);
    });

    return number??'';
  }

  static const Map<String, String> _englishToBanglaUnits = {
    'Measured': 'পরিমাপকৃত',
    'A+': 'এ+',
    'A-': 'এ-',
    'B+': 'বি+',
    'B-': 'বি-',
    'AB+': 'এবি+',
    'AB-': 'এবি-',
    'O+': 'ও+',
    'O-': 'ও-',
    'Very Low': 'মাত্রাতিরিক্ত কম',
    'Low': 'কম',
    'Moderate': 'উচ্চ স্বাভাবিক',
    'Very High': 'মাঝারি উচ্চ',
    'High': 'মৃদু উচ্চ',
    'Normal': 'স্বাভাবিক',
    'Underweight': 'কম ওজন',
    'Overweight': 'বেশি ওজন',
    'Obese': 'স্থুলতা',
    'Excellent': 'চমৎকার',
    'Alert': 'সতর্কতা',
    'Danger': 'বিপদ',
  };
  static String convertToLocalizedResult(String text) {
    if(!isLocaleBn()) return text;

    String unit = text.contains(' ') ? text.substring(text.indexOf(' ') + 1) : text;
    String? convertedText;
    for (var entry in _englishToBanglaUnits.entries) {
      if(unit.contains(entry.key)) {
        convertedText = text.replaceAll(entry.key, entry.value);
        break;
      }
    }
    return convertedText??text;
  }

  static String convertToLocalizedUnit(String text) {
    if(isLocaleBn()) {
      return _englishToBanglaUnits[text]??text;
    }
    return text;
  }


  static double getInchFromCentimeter(double? centimeter){
    if(centimeter == null)return  0;
    return (centimeter/2.54).remainder(12);
  }

  static double getCentimeterFromInch(double? inch){
    if(inch == null)return  0;
    return (inch*2.54);
  }

  static double getCentimeterFromFeetInch(double? feet, double? inch){
    feet ??= 0;
    inch ??= 0;

    return (feet*12+inch)*2.54;
  }
  static int getFeetFromCentimeter(double? centimeter){
    if(centimeter == null)return  0;
    return (centimeter~/30.48);
  }

  static double getKgFromLb(double? lb){
    if(lb == null)return  0;
    return lb / 2.205;
  }

  static bool notNullOrEmpty(String? data){
    if(data == null) return false;
    if(data.trim().isNotEmpty) return true;
    return false;
  }

  static bool isLocaleEn() {
    return Get.locale == null || Get.locale.toString() == 'en_US';
  }

  static String fontFamily() {
    return isLocaleBn()? 'kalpurush': 'Roboto';
  }

  static bool isLocaleBn() {
    return Get.locale.toString() == 'bn_BD';
  }

  static bool isLocaleKn() {
    return Get.locale.toString() == 'kn_IN';
  }

  static String getCommaSeperatedValue(List<String?> listOfString) {
    final nonEmptyParts = listOfString.where((e) => e != null && e.trim().isNotEmpty).toList();
    return nonEmptyParts.join(', ');
  }

  static dynamic tr(dynamic en,{dynamic bn, dynamic kn}) {
    if (isLocaleBn() && bn != null) {
      return bn;
    } else if (isLocaleKn() && kn != null) {
      return kn;
    } else {
      if(en is String) {
        return en.tr;
      }
      return en;
    }
  }

  static String getDefaultProfileAsset(int? gender) {
    if(gender == 1) {
      return "assets/images/ic_male.svg";
    } else if(gender == 2) {
      return "assets/images/ic_female.svg";
    } else if(gender == 3) {
      return "assets/images/ic_transgender.svg";
    }
    return "assets/images/ic_agent.svg";
  }

  static bool isLoggedIn() {
    return GetStorage().read(CommonKey.isLoggedIn)??false;
  }

  static void popUntilOrPush({required String routeName}) {
    if (Get.currentRoute != routeName) {
      bool found = false;

      // Check if routeName exists in the current navigation stack
      Get.until((route) {
        if (route.settings.name == routeName) {
          found = true;
          return true; // stop popping when found
        }
        return false; //popping continue
      });

      // If routeName was not found, push it
      if (!found) {
        Get.offNamedUntil(routeName, (route) => false);
      }
    }
  }

}

extension StringExtension on String {
  String? nullIfEmpty() => this.isNotEmpty ? this : null;
  //String trDigit() => Get.locale.toString() == 'bn_BD' ? Utils.getDigitBanglaFromEnglish(this)??"" : this;
  String trDigit() => this;
  String trDate() => Utils.isLocaleBn() ? Utils.getDateBanglaFromEnglish(this)??"" : this;
  String trAmount() => Utils.isLocaleBn() ? Utils.getDigitBanglaFromEnglish(this)??"" : this;
  String trUnit() => Utils.isLocaleBn() ? Utils.convertToLocalizedUnit(this) : this;
  String trimIfSpace() {
    if (length == 0) {
      return "";
    }
    if (this[0] == " ") {
      return this.trim();
    }

    return this;
  }

  String trimIfZero() {
    if (length == 0) {
      return "";
    }
    if (length > 1 && this[0] == "0") {
      return this.replaceRange(0, 1, '');
    }

    return this;
  }

  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

}

extension IntExtension on int {
  int? nullIfZero() => this == 0 ? null : this;
}

extension DoubleExtension on double {
  String toTwoDecimalDigit() =>
      this.toStringAsFixed(this.truncateToDouble() == this ? 0 : 2);

  double toTwoDecimal() => double.parse(this.toStringAsFixed(this.truncateToDouble() == this ? 0 : 2));

}

extension BoolExtension on bool? {
  bool get isNullOrEmpty => this == null || (this.isBlank??true);
}



extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

List<T> addUnique<T>(List<T> originalList, T newItem) {
  if (!originalList.contains(newItem)) {
    originalList.add(newItem);
  }
  return originalList;
}

FormFieldValidator<Object?> ValidationWrapper(FormFieldValidator<Object?> validator, {bool? isRequired, bool? isAapplyValidation}) {
  return (value) {
    if(isAapplyValidation??true){ //always validate
      if(!(isRequired??false)) { //support empty though validation exist //if not required then retun (null or no validation if empty)
        if (value == null || value.toString().isEmpty) return null;
      } else {
        return validator(value);
      }
    }
    return validator(value);
  };
}