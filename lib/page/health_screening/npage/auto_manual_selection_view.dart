import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/widget/basic_app_bar.dart';
import '../dto/measurement_dto.dart';
import '../health_screening_home_i18n.dart';
import 'auto_manual_selection_logic.dart';

class AutoManualSelectionView extends RapidView<AutoManualSelectionLogic> {
  static String routeName = '/auto_manual_selection_view';

  @override
  Widget build(BuildContext context) {
    controller.setImageAndRoute();
    return Scaffold(
      appBar: BasicAppBar(
        'label_health_screening'.tr,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[200], // Set the background color to a light grey
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() =>
                    controller.code.value == MeasurementType.BLOOD_SUGAR.value ?
                    Image.asset(
                      controller.image.value,
                      height: 300,
                      width: 300,
                    ) :
                    SvgPicture.asset(
                      controller.image.value,
                      height: 200,
                      width: 200,
                    )
                    ),
                  ],
                ),
              ),
              // Separate the logic for isBodyFat and isBMI
              Obx(() {
                if (controller.isBodyFat.value) {
                  return _buildBodyFatSection();
                } else if (controller.isBMI.value) {
                  return _buildBMISection();
                } else {
                  return _buildDefaultSection();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Body Fat Section
  Widget _buildBodyFatSection() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          // Row with blue background and white text
          Container(
            width: double.infinity, // Full width
            color: Theme.of(Get.context!).primaryColorLight, // Background color
            padding: const EdgeInsets.all(10.0), // Padding for text
            child: Text(
              'label_device_place_adv'.tr,
              style: TextStyle(
                color: Theme.of(Get.context!).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
          ),
          // Other body fat related UI
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Image.asset('assets/images/measurement/ic_power_connect.png', width: 50,),
                     const SizedBox(width: 16),
                     Expanded(
                      child: Text(
                        'label_connect_and_get_result'.tr,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: controller.isAutoFeatureEnable.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(Get.context!).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          controller.connectRoute.value,
                          arguments: [
                            {
                              "heightUnit": Get.arguments['heightUnit'],
                              "heightInCm": Get.arguments['heightInCm'],
                              "heightInFeet": Get.arguments['heightInFeet'],
                              "heightInInch": Get.arguments['heightInInch']
                            }
                          ]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            'label_connect'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BMI Section
  Widget _buildBMISection() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          // Row with blue background and white text
          Container(
            width: double.infinity, // Full width
            color: Theme.of(Get.context!).primaryColorLight, // Background color
            padding: const EdgeInsets.all(10.0), // Padding for text
            child: Text(
              'label_place_the_device_on_an_even_horizontal_place'.tr,
              style: TextStyle(
                color: Theme.of(Get.context!).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
          ),
          // Other BMI related UI
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: controller.isAutoFeatureEnable.value,
                      child: Expanded(
                        child: Card(
                          elevation: 4,
                          color: Theme.of(Get.context!).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(controller.connectRoute.value, arguments: [
                                {
                                  "heightUnit": Get.arguments['heightUnit'],
                                  "heightInCm": Get.arguments['heightInCm'],
                                  "heightInFeet": Get.arguments['heightInFeet'],
                                  "heightInInch": Get.arguments['heightInInch']
                                }
                              ]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'label_connect'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Theme.of(Get.context!).primaryColorLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(controller.manualRoute.value, arguments: [
                              {
                                "heightUnit": Get.arguments['heightUnit'],
                                "heightInCm": Get.arguments['heightInCm'],
                                "heightInFeet": Get.arguments['heightInFeet'],
                                "heightInInch": Get.arguments['heightInInch']
                              }
                            ]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'label_manual'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(Get.context!).primaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Default Section (when neither BodyFat nor BMI is selected)
  Widget _buildDefaultSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              color: Theme.of(Get.context!).primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed(controller.manualRoute.value);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'label_manual'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(Get.context!).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: controller.isAutoFeatureEnable.value,
            child: Expanded(
              child: Card(
                elevation: 4,
                color: Theme.of(Get.context!).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(controller.connectRoute.value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'label_connect'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    Get.lazyPut<AutoManualSelectionLogic>(() => AutoManualSelectionLogic());
  }
}


