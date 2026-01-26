import 'package:flutter_rapid/flutter_rapid.dart';
import 'xxxxx_i18n.dart';
import 'xxxxx_logic.dart';


class XXXXXView extends RapidView<XXXXXLogic> {
  static String routeName = "/xxxxx";

  const XXXXXView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XXXXX"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("View Body Text"),
          ],
        ),
      ),
    );
  }

  @override
  void loadDependentLogics() {
    Get.lazyPut<XXXXXLogic>(() => XXXXXLogic());
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return XXXXXI18N.getTranslations();
  }
}
