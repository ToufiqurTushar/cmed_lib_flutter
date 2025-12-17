import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import 'package:cmed_lib_flutter/common/common_key.dart';
import 'package:cmed_lib_flutter/common/dto/agent_profile_dto.dart';
import 'package:cmed_lib_flutter/common/dto/bkash_make_payment_response_dto.dart';
import 'package:cmed_lib_flutter/common/dto/cancel_agreement_dto.dart';
import 'package:cmed_lib_flutter/common/dto/nagad_make_payment_response_dto.dart';
import 'package:cmed_lib_flutter/common/enum/payment_method_enum.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:flutter_rapid/logic/rapid_global_state_logic.dart';
import 'package:cmed_lib_flutter/common/dto/user_profile_dto.dart';
import 'package:cmed_lib_flutter/common/dto/customer_dto.dart';
import 'package:get_storage/get_storage.dart';

class ProfileRepository {
  final HttpProvider provider = Get.find();
  final RapidGlobalStateLogic globalState = Get.find();


  Future<UserProfile?> receiveData(String path, {bool checkForceUpdate = false}) async {
    try {
      var response = await provider.GET(path);
      if (response.isOk) return UserProfile.fromJson(response.body);
      return null;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<UserProfile?> sendData(String path, data) async {
    var profile = data as UserProfile;
    profile.disabilities ??= [];
    profile.patientAllergicHistory ??= PatientAllergicHistory();
    profile.drugHistoryList ??= [];
    profile.comorbidityList ??= [];
    profile.injuries ??= [];
    profile.surgeries ??= [];

    try {
      var response = await provider.PATCH(path, profile.toJson());
      if (response.status.hasError) return null;
      return UserProfile.fromJson(response.body);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<CustomerDTO?> updateSelectedCustomerHeight(CustomerDTO customer) async {
    await receiveData(ApiUrl.getCustomProfileByUserIdUrl(customer.userId)).then((UserProfile? profile) async => {
      if (profile != null){
        profile.height = customer.heightCentimeter,
        globalState.currentUser.value = customer,
        await sendData(ApiUrl.getCustomProfileByUserIdUrl(customer.userId), profile).then((UserProfile? value) async {
          if(value != null) {
            updatedProfileToLocalStorage(value);
            // var response = await provider.GET(AllUrl.getCustomerByUserId(customer.userId, customer.companyId));
            // if (response.isOk) {
            //   globalState.currentUser.value = CustomerDTO.fromJson(response.body);
            //   return globalState.currentUser.value;
            // }
            return customer;
          }
        }),
      }
    });
    return null;
  }

  updatedProfileToLocalStorage(UserProfile up) {
    GetStorage().write(CommonKey.keySelectedUserProfileDTO, up.toJson());
  }

  Future <BkashMakePaymentResponseDto?>makeBkashPayment(String paymentUrlQueryPath) async {
    try {
      final response = await provider.POST(ApiUrl.getPaymentURL(paymentMethod: PaymentMethodEnum.bkash, paymentUrlQueryPath: paymentUrlQueryPath), null);
      if (response.status.hasError) return null;
      return BkashMakePaymentResponseDto.fromJson(response.body);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<AgentProfileDto?> getAgentProfile() async {
    try {
      var response = await provider.GET(ApiUrl.getCurrentAgentProfile());
      if (response.isOk) return AgentProfileDto.fromJson(response.body);
      return null;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future <CancelAgreementDto?>cancelBkashAgreement(String param, dynamic data) async {
    try {
      final response = await provider.POST(param, data);
      if (response.status.hasError) return null;
      return CancelAgreementDto.fromJson(response.body);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }


  Future <NagadMakePaymentResponseDto?>makeNagadPayment(String paymentUrlQueryPath) async {
    try {
      final response = await provider.POST(ApiUrl.getPaymentURL(paymentMethod: PaymentMethodEnum.nagad, paymentUrlQueryPath:paymentUrlQueryPath), null);
      if (response.status.hasError) return null;
      return NagadMakePaymentResponseDto.fromJson(response.body);
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }
}
