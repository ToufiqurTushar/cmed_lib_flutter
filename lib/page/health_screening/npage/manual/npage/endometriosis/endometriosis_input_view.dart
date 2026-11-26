import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/endometriosis/endometriosis_input_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bp/bp_input_logic.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import 'package:endometriosis_lib_flutter/endometriosis/npage/screening/endometriosis_screening_logic.dart';
import 'package:endometriosis_lib_flutter/endometriosis/npage/screening/endometriosis_screening_view.dart';
import 'package:endometriosis_lib_flutter/endometriosis/repository/endometriosis_repository.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_rapid/logic/rapid_global_state_logic.dart';

import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_birth_date_picker.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import '../../../../../../common/converter.dart';
import '../../../../../../common/dto/user_profile_dto.dart';
import '../../../../../../common/widget/basic_app_bar.dart';
import '../../../../../../common/widget/cmed_primary_elevated_button.dart';
import '../../../../../../common/widget/widget_v2.dart';
import 'endometriosis_input_logic.dart';


class EndometriosisInputView extends RapidView<EndometriosisInputLogic> {
  static String routeName = '/EndometriosisInputView';

  @override
  Widget build(BuildContext context) {
    return EndometriosisScreeningView();
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: widgetV(
        v2: GradientWhiteToPrimary(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: controller.isNestedRoute? null: BasicAppBarV2('label_blood_pressure'.tr),
            body: Expanded(child: EndometriosisScreeningView()),
          ),
        ),
        v1: Scaffold(
            appBar: BasicAppBar('label_blood_pressure'.tr),
            body: SafeArea(
              child: Expanded(child: EndometriosisScreeningView()),
            ),
          ),
      ),
      
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
   return EndometriosisInputI18n.getTranslations();
  }


  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.put(ScreeningReportRepository());
    Get.put(EndometriosisRepository());

    CustomerDTO customer = CustomerDTO();
    var user = Get.find<RapidGlobalStateLogic>().currentUser.value;
    if(user is CustomerDTO) {
      customer = user;
    } else if(user is UserProfile) {
      customer = user.toCustomer();
    }
    final height = cmToFeetAndInches(customer.heightCentimeter, decimals: 2);

    RLog.error(customer.toJson());

    final inputLogic = Get.put(
      EndometriosisInputLogic(
        userIdWhileInitLogic: customer.userId!,
        birthDateWhileInitLogic: customer.birthDate!,
        heightInFeetWhileInitLogic: height.feet,
        heightInInchiWhileInitLogic: height.inches,
        weightInKgWhileInitLogic: customer.weight,
      ),
    );
    Get.put<EndometriosisScreeningLogic>(inputLogic);
  }

  static Widget widgetV({required Widget v1, Widget? v2}) {
    if (Get.find<EndometriosisInputLogic>().isThemeV2) {
      return v2 ?? v1;
    }
    return v1;
  }

}
