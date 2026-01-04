import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static String CMED_WEB_SITE_URL = 'https://cmed.com.bd/';
  static String CMED_PRIVACY_POLICY_URL = 'https://cmed.com.bd/?page_id=2849';
  static String EKPAY_URL = 'https://ekpay.gov.bd/#/bill-payment/electricity';
  static String TERM_CONDITION_AND_POLICY_URL = 'https://cmed.com.bd/?page_id=2849';
  static String SWASTI_TERM_CONDITION_AND_POLICY_URL = 'https://swasti.org/legal';
  static String APPLE_STORE_URL = 'https://apps.apple.com/us/app/cmed-health/id1505328545';
  static String PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.cmedhealth.android';
  static String CMED_FACEBOOK = 'https://facebook.com/CMEDHealth/';
  static String CMED_LINKEDIN = 'https://linkedin.com/company/cmedhealth/';
  static String CMED_YOUTUBE = 'https://youtube.com/cmedhealth';
  static String CMED_MAP_URL = "https://goo.gl/maps/2wbnpbmAuCsFucZC9";
  static String CMED_PHONE = "01742925686";
  static String SWASTI_PHONE = "+917893219967";
  static String CMED_EMAIL = "info@cmedhealth.com";

  static void launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $url';
    }
  }

  static void launchEmail(String email) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': '',
      }),
    );
    launchUrl(emailLaunchUri);
  }
  static void launchTel(String phone) async {
    final call = Uri.parse('tel:$phone');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw "Can't open Phone App in your device";
    }
  }
}