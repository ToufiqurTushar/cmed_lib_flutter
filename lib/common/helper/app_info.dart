import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<List<String>> getAppInfoList() async {
    List<String> appInfoList = [];
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      appInfoList.add(version);
      appInfoList.add(code);
    } catch (e) {
      appInfoList.add("1.0.0");
      appInfoList.add('1');
    }
    return appInfoList;
  }

  static Future<String> getVersionNumber() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return "1.0.0";
    }
  }

  static Future<String> getAppId() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }

  static Future<String> getBuildNumberNumber() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      return "1";
    }
  }

  static Future<String> getVersionWithBuildNumber() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      return "$version ($code)";
    } catch (e) {
      return "2.0.0 (2)";
    }
  }

  static Future<String> getUniqueDeviceId() async {
    //if found on pref
    RapidPreferenceStore preferenceStore = Get.find();
    String? uniqueDeviceId = preferenceStore.read('device_uuid');
    if (uniqueDeviceId != null) {
      return uniqueDeviceId;
    }

    //using Device Info Plus package
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.model}:${iosDeviceInfo.identifierForVendor}'; //unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}' ; // unique IDon Android
    }
    preferenceStore.save('device_uuid', uniqueDeviceId);
    return uniqueDeviceId!;
  }
}
