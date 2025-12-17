import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/blood_glucose/blood_glucose_auto_select_time_period_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/auto/npage/blood_glucose/blood_glucose_device_connection_view.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_dropdown_view.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';


class BloodGlucoseAutoSelectTimePeriodView
    extends RapidView<BloodGlucoseAutoSelectTimePeriodLogic> {
  static String routeName = '/blood_glucose_auto_select_time_period_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar('label_blood_glucose'.tr),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                shadowColor: Theme.of(context).primaryColor,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          'label_select_time_period'.tr,
                          style: CMEDTextUtils.inputTextLabelStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CMEDDropdownWidget(getTimePeriods(),
                                  dropdownTitle: 'label_select_time_period'.tr,
                                  onItemSelected: (data) {
                            controller.selectedItem.value = data;
                          })),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: CMEDWhiteElevatedButton(
                      'label_next'.tr,
                      () => {
                        if (controller.selectedItem.value.id != null){
                            controller.requestMicrophonePermissionAndNavigate(),
                        }
                        else {
                            ShowToast.error('error_select_time_period'.tr)
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTimePeriods() {
    if (int.parse((CustomDateUtils.getYearFromLong(
                controller.customer.value.birthDate)
            .replaceAll("Y", ""))) >
        18) {
      return [
        MasterDataDTO(labelEn: 'Random', labelBn: 'যেকোনো সময়', id: 9, image: 'assets/images/blood_grouping/ic_medium_random.png'),
        MasterDataDTO(labelEn: 'Fasting', labelBn: 'খালি পেটে', id: 10, image: 'assets/images/blood_grouping/ic_fasting.png'),
        MasterDataDTO(labelEn: 'OGTT', labelBn: 'ওজিটিটি', id: 11, image: 'assets/images/blood_grouping/ic_ogtt.png'),
        MasterDataDTO(labelEn: '2hr AFB(After Breakfast)', labelBn: 'খাবারের দুই ঘন্টা পর', id: 12, image: 'assets/images/blood_grouping/ic_2hab.png')
      ];
    } else {
      return [MasterDataDTO(labelEn: 'Random', labelBn: 'যেকোনো সময়', id: 9, image: 'assets/images/blood_grouping/ic_medium_random.png')];
    }
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
    Get.put(BloodGlucoseAutoSelectTimePeriodLogic());
  }
}
