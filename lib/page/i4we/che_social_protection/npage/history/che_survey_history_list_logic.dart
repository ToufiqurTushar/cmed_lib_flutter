import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/survey/dto/survey_item_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/api/api_url.dart';
import '../../../../../common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';


class CheSurveyListLogic extends BaseLogic {
  final HttpProvider httpProvider = Get.find();
  final isHistoryView = false.obs;

  final surveyResultList = <SurveyResultItemDto>[].obs;
  final selectedSurveyResult = SurveyResultItemDto().obs;

  @override
  void onInit() {
    super.onInit();

  }



  @override
  void onReady() {
    super.onReady();
    getData();
  }

  @override
  void onClose() {

  }

  getData() async {
    globalState.showBusy();
    httpProvider.GET(ApiUrl.getCheSurveySurveyUrl(customer.value.userId!)).then((response){
      globalState.hideBusy();
      if(response.isOk) {
        surveyResultList.addAll(SurveyResultItemDto.fromJsonList(response.body['content']));
      } else {
        ShowToast.error('something_wrong'.tr);
      }
    });
  }
}
