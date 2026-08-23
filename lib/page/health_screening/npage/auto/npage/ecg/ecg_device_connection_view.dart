import 'dart:convert';

import 'package:cmed_ecg_devices_lib/ecg_graph_view.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_primary_elevated_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/ecg/ecg_device_connection_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:get/get.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_button.dart';
import 'package:cmed_lib_flutter/common/widget/device/cmed_measurement_running_message.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import '../../../../dto/measurement_dto.dart';
import '../../enum/screen_enum.dart';

class EcgDeviceConnectionView extends RapidView<EcgDeviceConnectionLogic> {
  static String routeName = '/ecg_device_connection_page';

  const EcgDeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.isNestedRoute? null:BasicAppBar('label_ecg'.tr),
      body: widgetV(
        v2: SafeArea(
          child: Column(
            children: [
              Obx(() => Expanded(
                child: Stack(
                  children: [
                    Visibility(
                      visible: controller.isResultFound.isFalse && (controller.screen_status.value ==
                          ScreenEnum.CONNECT.name ||
                          controller.screen_status.value ==
                              ScreenEnum.DEVICE_NOT_FOUND.name ||
                          controller.screen_status.value ==
                              ScreenEnum.DISCONNECTED.name),
                      child: Center(
                        child: Obx(
                              () => CMEDDeviceConnectionButton(
                            controller.buttonText.value,
                            Icons.bluetooth,
                                () {
                              controller.connect();
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.screen_status.value ==
                          ScreenEnum.SEARCHING.name || controller.screen_status.value ==
                          ScreenEnum.CONNECTING.name,
                      child: Center(
                        child: Obx(
                              () => CMEDDeviceConnectionButton(
                            controller.buttonText.value,
                            Icons.bluetooth,
                                () {},
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.screen_status.value ==
                          ScreenEnum.CONNECTED.name,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 240,
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight  ,
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    )),
                                child: ECGGraphView(
                                    onMapViewCreated: _onMapViewCreated,
                                    text: '${controller.reading}')),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: LinearProgressIndicator(
                                  value: (double.parse(
                                      controller.progress.value) /
                                      38),
                                  minHeight: 6,
                                  color: Theme.of(context).primaryColor,
                                  backgroundColor:
                                  Colors.grey,
                                )),
                          ),
                          const Spacer(),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'label_pulse'.tr,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 48,
                              ),
                              Text(
                                'unit_bpm'.tr,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: Text(
                              controller.reading.value,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CMEDMeasurementRunningMessage(
                                'label_please_wait_while_taking_measurement'.tr),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: controller.screen_status.value ==
                          ScreenEnum.RESULT_FOUND.name,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 240,
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight  ,
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    )),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/screening/ecg_graph.png', package: 'cmed_lib_flutter', fit: BoxFit.cover, width: double.infinity, height: 200,),
                                    // ECGGraphView(
                                    //     onMapViewCreated: _onMapViewCreated,
                                    //     text: controller.reading.value),
                                  ],
                                )),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: LinearProgressIndicator(
                                  value: (double.parse(
                                      controller.progress.value) /
                                      38),
                                  minHeight: 6,
                                  color: Theme.of(context).primaryColor,
                                  backgroundColor:
                                  Colors.grey,
                                )),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    Obx(() {
                      return Visibility(
                          visible: controller.isLoading.value,
                          child: const Center(
                              child: CircularProgressIndicator()));
                    }),
                    Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: InkWell(
                          onTap: (){
                            changeEvent(context);
                          },
                          child: Text('ChangeEvent')
                      ),
                    ),
                    Visibility(
                      visible: controller.screen_status.value ==
                          ScreenEnum.RESULT_FOUND.name,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(99),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.screen_status.value ==
                          ScreenEnum.RESULT_FOUND.name,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 320,
                          height: 170,
                          child: Card(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  controller.getInputText(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: CMEDPrimaryElevatedButton(
                                          'label_next'.tr,
                                              () => {
                                            controller.sendMeasurement()
                                          },
                                          buttonBgColor: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          height: 42,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        v1: SafeArea(
          child: Column(
            children: [
              Obx(() => Expanded(
                    child: Stack(
                      children: [
                        Visibility(
                          visible: controller.isResultFound.isFalse && (controller.screen_status.value ==
                                  ScreenEnum.CONNECT.name ||
                              controller.screen_status.value ==
                                  ScreenEnum.DEVICE_NOT_FOUND.name ||
                              controller.screen_status.value ==
                                  ScreenEnum.DISCONNECTED.name),
                          child: Center(
                            child: Obx(
                              () => CMEDDeviceConnectionButton(
                                controller.buttonText.value,
                                Icons.bluetooth,
                                () {
                                  controller.connect();
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.screen_status.value ==
                              ScreenEnum.SEARCHING.name || controller.screen_status.value ==
                        ScreenEnum.CONNECTING.name,
                          child: Center(
                            child: Obx(
                              () => CMEDDeviceConnectionButton(
                                controller.buttonText.value,
                                Icons.bluetooth,
                                () {},
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.screen_status.value ==
                              ScreenEnum.CONNECTED.name,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 240,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColorLight  ,
                                        borderRadius: BorderRadius.circular(
                                          16,
                                        )),
                                    child: ECGGraphView(
                                        onMapViewCreated: _onMapViewCreated,
                                        text: '${controller.reading}')),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: LinearProgressIndicator(
                                      value: (double.parse(
                                              controller.progress.value) /
                                          38),
                                      minHeight: 6,
                                      color: Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Colors.grey,
                                    )),
                              ),
                              const Spacer(),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'label_pulse'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  Text(
                                    'unit_bpm'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  controller.reading.value,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CMEDMeasurementRunningMessage(
                                    'label_please_wait_while_taking_measurement'.tr),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: controller.screen_status.value ==
                              ScreenEnum.RESULT_FOUND.name,
                          child: Stack(
                            children: [
                              // Column(
                              //   children: [
                              //     const Spacer(),
                              //     Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: CMEDMeasurementRunningMessage(
                              //           'label_please_wait_while_taking_measurement'.tr),
                              //     )
                              //   ],
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(70),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 320,
                                  height: 220,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'label_measurement_store_warning'.tr,
                                          textAlign: TextAlign.center,
                                          style:
                                          CMEDTextUtils.alertTitleTextStyle,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          controller.getInputText(),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CMEDPrimaryElevatedButton(
                                                'yes'.tr,
                                                    () => {
                                                  controller.sendMeasurement()
                                                },
                                                buttonBgColor: Theme.of(context).primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 42,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CMEDPrimaryElevatedButton(
                                                'no'.tr,
                                                    () => {
                                                  controller
                                                      .screen_status.value =
                                                      ScreenEnum.CONNECT.name,Get.back(),
                                                },
                                                buttonBgColor: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                height: 42,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Visibility(
                              visible: controller.isLoading.value,
                              child: const Center(
                                  child: CircularProgressIndicator()));
                        }),
                        Align(
                          alignment: AlignmentGeometry.topCenter,
                          child: InkWell(
                              onTap: (){
                                changeEvent(context);
                              },
                              child: Text('ChangeEvent')
                          ),
                        ),
                        // Container(child: Text(""),),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _onMapViewCreated(ECGGraphViewController controller) {
    this.controller.ecgGraphViewController = controller;
    this.controller.ecgGraphViewController.initView();
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return HealthScreeningHomeI18N.getTranslations();
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.put(ScreeningReportRepository());
    Get.put(EcgDeviceConnectionLogic(repository: Get.find<ScreeningReportRepository>()));
  }

  void changeEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an Item'),
          content: SizedBox(
            // Essential: Gives the AlertDialog a finite width boundary
            width: double.maxFinite,
            child: Column(
              children: [

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.isResultFound.value = true;
                controller.progress.value = 100.0.toString();
                controller.screen_status.value = ScreenEnum.RESULT_FOUND.name;
                String jsonString = '''{
     "input": {
          "breath": "15",
          "heartage": "31",
          "hrmax": "98",
          "hrmean": "92",
          "hrmin": "86",
          "hrv": "19",
          "pbcnt": "0",
          "pressure": "78",
          "suspectedflag": "0"
     },
     "ecgsymps": [
          {
               "name": "Normal Electrocardiogram",
               "symp_name_bn": "স্বাভাবিক ইলেক্ট্রোকার্ডিওগ্রাম",
               "suggestion": "Test result indicates that your electrocardiogram was regular, and no abnormalities were found. We recommended you to form good living habits, eat more green vegetables and fruits, exercise regularly, defecate regularly and avoid staying up late.",
               "suggestion_bn": "আপনার ইলেক্ট্রোকার্ডিওগ্রাম পরীক্ষার ফলাফল স্বাভাবিক। সঠিক জীবনাচারণ, নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই স্বাভাবিক অবস্থা বজায় রাখুন।",
               "symp_desc": "In the present test, the waveform of the electrocardiogram was regular, and no abnormalities were found. We recommended you form good living habits, eat more green vegetables and fruits, exercise regularly, defecate regularly and avoid staying up late.",
               "symp_desc_bn": "আপনার ইলেক্ট্রোকার্ডিওগ্রামের ফলাফল স্বাভাবিক।",
               "color_code": "#43A047",
               "sympcode": "0.0"
          },
          {
               "name": "Anxiety",
               "symp_name_bn": "দুশ্চিন্তা",
               "suggestion": "Test result indicates that your mental state is biased towards Anxity. We recommended you to relax, do moderate exercise and increase communication with people.",
               "suggestion_bn": "ইলেক্ট্রোকার্ডিওগ্রাম পরীক্ষার ফলাফল অনুযায়ী আপনার মানসিক অবস্থা উদ্বেগ প্রবণ। আপনাকে চিন্তামুক্ত থাকার, নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণ এবং মানুষের সাথে যোগাযোগ বাড়ানোর পরামর্শ দেয়া হলো।",
               "symp_desc": "Your mental state is biased towards anxiety, which may be caused by work and life stress, frequent social activities and stay up late to work overtime. In the long run, both physiology and psychology will be damaged, and the immune system will be affected to liable to disease. We recommended that you should improve your habits, keep your mood relaxed, do moderate exercise and take more deep breathes.",
               "symp_desc_bn": "সময় এবং পরিবেশের সাথে সাথে মানুষের  মানসিক বা শারীরবৃত্তীয় চাপ আলাদা হয়। মনস্তাত্ত্বিক চাপ সাধারণত বর্তমান সময়ের মেজাজ, মনের অবস্থা, ইত্যাদি প্রকাশ করে।  যখন মনস্তাত্ত্বিক চাপ স্বাভাবিক থাকে তখন মন এবং দেহ অনেক ভাল অবস্থায় থাকে, শরীরে কোনও অস্বস্তি থাকে না, মন এবং মেজাজ থাকে শান্ত। অপরদিকে মনস্তাত্ত্বিক চাপ যখন অনেক বেশি থাকে, তখন শরীর প্রায়শই ক্লান্ত থাকে এবং মন থাকে অশান্ত এবং উদ্বিগ্ন। সংশ্লিষ্ট  ব্যক্তি শরীরে ক্লান্তি এবং দূর্বলতা অনুভব করেন, সাথে থাকতে পারে বিরক্তি, বিষণ্ণতা, হতাশা এবং একাগ্রতার অভাব। এর সাথে  অন্যান্য শারীরিক এবং মানসিক অসুস্থতাও থাকতে পারে। তাই সময়মত এই  মনস্তাত্ত্বিক চাপ থেকে মুক্ত হওয়া উচিত।",
               "color_code": "#FFD38817",
               "sympcode": "0.003"
          }
     ],
     "outcome": null,
     "id": null,
     "uuid": null,
     "created_at": null,
     "last_updated": null,
     "created_by_id": null,
     "updated_by_id": null,
     "member_id": null,
     "app_id": null,
     "client_id": null,
     "user_id": 4302821,
     "user_uuid": null,
     "user_full_name": null,
     "user_full_name_bn": null,
     "user_phone_number": null,
     "user_date_of_birth": null,
     "gender": null,
     "user_email": null,
     "user_nid": null,
     "measurement_type_code_id": 7,
     "measurement_type_name": "Electrocardiogram",
     "measurement_type_code": "ECG",
     "bundle_id": null,
     "result": {
          "value": 92.0,
          "status": "Normal Electrocardiogram",
          "severity": "Normal Electrocardiogram",
          "remarks": null,
          "suggestion": "Test result indicates that your electrocardiogram was regular, and no abnormalities were found. We recommended you to form good living habits, eat more green vegetables and fruits, exercise regularly, defecate regularly and avoid staying up late.",
          "suggestion_bn": "আপনার ইলেক্ট্রোকার্ডিওগ্রাম পরীক্ষার ফলাফল স্বাভাবিক। সঠিক জীবনাচারণ, নিয়মিত ব্যায়াম, দৈহিক পরিশ্রম ও সুষম খাবার গ্রহণের মাধ্যমে এই স্বাভাবিক অবস্থা বজায় রাখুন।",
          "eng_advice": null,
          "bn_advice": null,
          "color_code": "#43A047",
          "status_bn": "স্বাভাবিক ইলেক্ট্রোকার্ডিওগ্রাম"
     },
     "measured_at": 1785667449169,
     "ecg_graph_value": "",
     "tag": null,
     "offline": null,
     "created_by_uuid": null,
     "company_id": null
}''';
                controller.reading.value = "IK_ECG_GRAPH_DATA:$jsonString";
                controller.ecgResult.value = ECG.fromJson(jsonDecode(jsonString));
                Navigator.pop(context);
              },
              child: const Text('Result Found'),
            ),
          ],
        );
      },
    );
  }

  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<EcgDeviceConnectionLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }
}
