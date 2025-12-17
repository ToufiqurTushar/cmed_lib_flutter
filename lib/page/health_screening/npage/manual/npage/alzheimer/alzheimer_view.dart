// import 'package:alzheimer_lib_flutter/alzheimer/alzheimer_home_i18n.dart';
// import 'package:alzheimer_lib_flutter/alzheimer/alzheimer_home_logic.dart';
// import 'package:alzheimer_lib_flutter/alzheimer/alzheimer_home_view.dart';
// import 'package:alzheimer_lib_flutter/alzheimer/repository/alzheimer_repository.dart';
//import 'package:alzheimer_lib_flutter/alzheimer/alzheimer_home_i18n.dart';
//import 'package:alzheimer_lib_flutter/alzheimer/alzheimer_home_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';


class AlzheimerView extends RapidView<RapidStartLogic> {
  static String routeName = "/alzheimer";

  const AlzheimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alzheimer"),
        foregroundColor: Theme.of(context).primaryColor,
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      body: Text('A')//AlzheimerHomeView(),
    );
  }

  @override
  void loadDependentLogics() {
    //Get.put(AlzheimerRepository());
    //Get.put(AlzheimerHomeLogic(userId: 4204630));
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {};//AlzheimerHomeI18n.getTranslations();
  }
}
