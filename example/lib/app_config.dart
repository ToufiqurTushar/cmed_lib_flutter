import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'test_survey/test_survey_view.dart';

class AppSystemConfig extends RapidSystemConfig {
  AppSystemConfig() {
    initialRoute = TestSurveyView.routeName;
    modules = [
      AppRegistry(),
    ];
    splashScreenData = RapidSplashScreenData()
        .setAppName(appTitle)
        .setCopyRight('CMED')
        .setLogo('assets/images/logo.png')
        .disable();

    navigatorObservers = [
      ChuckerFlutter.navigatorObserver,
    ];

    availableEnvironment = {
      'dev': DevConfig()
    };
  }

  initConfig(var env) {
    return Get.put<RapidEnvConfig>(env);
  }

  Future<void> onAppStartup() async {
    ChuckerFlutter.showNotification = true;
    ChuckerFlutter.isDebugMode = true;
    Get.put(HttpProvider(appUid: AppUidEnum.i4WeAgent), permanent: true);
  }
}

class AppRegistry extends RapidModuleRegistry {
  @override
  List<RapidView> getPages() {
    return [
      TestSurveyView()
    ];
  }
}
class DevConfig extends RapidEnvConfig {
  DevConfig() {
    baseUrl = "https://core-dev.cmedhealth.com/";
  }
}