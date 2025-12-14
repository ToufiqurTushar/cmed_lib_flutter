import 'package:cmed_lib_flutter/common/dto/user_profile_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';

import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';


abstract class BaseLogic extends RapidStartLogic {
  final httpProvider = Get.find<HttpProvider>();
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var customer = CustomerDTO().obs;

  @override
  void onInit() {
    super.onInit();

    if(globalState.currentUser.value is CustomerDTO) {
      customer.value = globalState.currentUser.value as CustomerDTO;
    } else if(globalState.currentUser.value is UserProfile) {
      customer.value = (globalState.currentUser.value as UserProfile).toCustomer();
    }
  }

  showLoader(){
    isLoading.value = true;
    Future.delayed(Duration.zero, () async {
      globalState.showBusy();
    });
  }

  hideLoader(){
    isLoading.value = false;
    globalState.hideBusy();
  }
}
