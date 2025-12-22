import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'api/api_url.dart';


class AppUidConfig {
  final RapidEnvConfig configInstance;
  final RapidPreferenceStore prefStoreInstance;
  static final AppUidConfig _instance = AppUidConfig._internal();
  AppUidConfig._internal()
      : configInstance = Get.find<RapidEnvConfig>(),
        prefStoreInstance = Get.find();
  factory AppUidConfig() => _instance;

  //get instance
  static RapidEnvConfig get config => AppUidConfig().configInstance;
  static RapidPreferenceStore get prefStore => AppUidConfig().prefStoreInstance;

  static bool get isCmedAgentApp => config.appUid == AppUidEnum.CmedAgentApp.name;
  static bool get isCmedUserApp => config.appUid == AppUidEnum.CmedUserApp.name;
  static bool get isCmedApp => isCmedAgentApp || isCmedUserApp;

  static bool get isI4WeAgentApp => config.appUid == AppUidEnum.I4WE_AGENT.name;
  static bool get isI4WeMemberApp => config.appUid == AppUidEnum.I4WE_MEMBER.name;
  static bool get isI4WeApp => isI4WeAgentApp || isI4WeMemberApp;


  static String getGlucoseLabelHint(String label) {
    if (isI4WeApp) {
      return "input_hint_glucose_mg_dl".tr;
    }
    return label;
  }

  static double getHueOnGreen() {
    if (isCmedAgentApp || isI4WeAgentApp) {
      return 0.55;
    }
    return 0.0;
  }

  static String getPostMeasurementUrl() {
    if(isCmedUserApp || isI4WeMemberApp) {
      return ApiUrl.addMeasurementUrl();
    }
    return ApiUrl.previewMeasurementUrl();
  }
}
