import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:get/get.dart';

class DigitConverter {
  static const Map<String, String> _englishToBanglaDigits = {
    '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪',
    '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯'
  };

  static const Map<String, String> _englishToBanglaMonths = {
    'Jan': 'জানু',
    'Feb': 'ফেব্রু',
    'Mar': 'মার্চ',
    'Apr': 'এপ্রিল',
    'May': 'মে',
    'Jun': 'জুন',
    'Jul': 'জুলাই',
    'Aug': 'আগস্ট',
    'Sep': 'সেপ্টে',
    'Oct': 'অক্টো',
    'Nov': 'নভে',
    'Dec': 'ডিসে',
  };

  /// Converts digits and short English month names to Bangla based on locale.
  static String convertToLocalizedNumbers(String text) {
    if (Utils.isLocaleBn()) {
      // Replace month names
      _englishToBanglaMonths.forEach((eng, bng) {
        text = text.replaceAll(eng, bng);
      });

      // Replace digits
      text = text.split('').map((char) => _englishToBanglaDigits[char] ?? char).join();
    }

    return text;
  }

  static String convertIntToLocalizedNumber(int number) {
    return convertToLocalizedNumbers(number.toString());
  }
}
