import 'package:flutter_rapid/flutter_rapid.dart';
import 'app_config.dart';


Future<void> main() async {
  AppSystemConfig appSystemConfig = AppSystemConfig();
  FlutterRapidApp flutterRapidApp = FlutterRapidApp();
  await flutterRapidApp.bStart(appSystemConfig);
  runApp(flutterRapidApp);
}