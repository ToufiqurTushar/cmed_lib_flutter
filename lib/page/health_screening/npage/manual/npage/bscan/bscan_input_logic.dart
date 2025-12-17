import 'package:cmed_lib_flutter/common/api/api_url.dart';
import 'package:cmed_lib_flutter/common/enum/yes_no_enum.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/dto/bscan_input_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';

import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import '../../../../dto/screening_report_result_details_argument.dart';


class BScanInputLogic extends BaseLogic {
  final ScreeningReportRepository repository;

  BScanInputLogic({required this.repository});

  final GlobalKey<FormState> screeningReportFormKey = GlobalKey<FormState>();
  var screeningReport = MeasurementDTO().obs;
  var pageSection = 1.obs;
  var lastPageSection = 11.obs;

  late TextEditingController dateController;
  late TextEditingController ageEditTextController;
  late TextEditingController heightInFeetEditTextController;
  late TextEditingController heightInInchEditTextController;
  late TextEditingController weightEditTextController;

  var age = 0.obs;
  var selecteedMenstrualCycleYear = MasterDataDTO().obs;
  var isMarried = RxnBool();
  var prfMarried = false;
  var hasChildren = RxnBool();
  var prfHaveChildren = false;
  var selecteedFirstChildBornYear = MasterDataDTO().obs;
  bool? prfChildBreastFeed;
  var hasBCInFamilyMember = RxnBool();
  bool? prfBreastDisease;
  var bcInFamilly = false;
  var frfMother = false;
  var frfSister = false;
  var frfDaughter = false;
  var frfMaternalAunt = false;
  var frfMaternalGrandmother = false;
  var frfPaternalAunt = false;
  var frfPaternalGrandmother = false;
  int? bsaDiscomfortorArmpit;
  int? bsaAbnormalSizeOrChangeShape;
  int? bsaDimpledOrNippleLikeAnOrange;
  int? bsaWoundOrUlcerNippleForTwoMonth;
  int? bsaNippleTurnedInwardsNotOutwards;
  int? bsaDischargeFromNippleAsBloodOrPus;
  int? bsaRednessTtLastTwoWeeks;
  int? bsaLumpOrSwelling;
  var swellingInArmpit = RxnInt();
  int? bsaLumpOrSwellingInArmpit;


  List<MasterDataDTO> yesNoList = YesNoEnum.getMasterDataList();

  List<MasterDataDTO> familyMemberRelationList = [
    MasterDataDTO(labelEn: "Mother",labelBn: "মা", value: 1),
    MasterDataDTO(labelEn: "Sister",labelBn: "বোন", value: 2),
    MasterDataDTO(labelEn: "Daughter",labelBn: "মেয়ে", value: 3),
    MasterDataDTO(labelEn: "Aunt (Maternal)",labelBn: "খালা", value: 4),
    MasterDataDTO(labelEn: "Grandmother (Maternal)",labelBn: "নানী", value: 5),
    MasterDataDTO(labelEn: "Aunt (Paternal)",labelBn: "ফুপু", value: 6),
    MasterDataDTO(labelEn: "Grandmother (Paternal)",labelBn: "দাদী", value: 7),
  ];

  ////////////////

  @override
  void onInit() {
    super.onInit();

    age.value = customer.value.getAgeInYear();
    if(age.value <=8) {
      age.value = 8;
    }

    dateController = TextEditingController();
    ageEditTextController = TextEditingController(text: age.value.toString());
    weightEditTextController = TextEditingController();
    heightInFeetEditTextController = TextEditingController();
    heightInInchEditTextController = TextEditingController();

    var height = customer.value.heightCentimeter;
    if(height != null) {
      heightInFeetEditTextController.text = Utils.getFeetFromCentimeter(customer.value.heightCentimeter).toString();
      heightInInchEditTextController.text = Utils.getInchFromCentimeter(customer.value.heightCentimeter).toStringAsFixed(1);
    }
  }


  bool isValidInput() {
    if(heightInInchEditTextController.text.isEmpty) {
      heightInInchEditTextController.text = "0";
    }
    return screeningReportFormKey.currentState!.validate();
  }
  bool isValidAgeRange(value) {
    if (!GetUtils.isNum(value) || GetUtils.isLowerThan(double.parse(value), MeasurementConstant.BSCAN_AGE_MIN) || GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.BSCAN_AGE_MAX)) {
     return false;
    }
    return true;
  }
  validateHeightInInch(String value) {
    if(value.isEmpty) {
      return null;
    }
    if (!GetUtils.isNum(value) || GetUtils.isLowerThan(double.parse(value), MeasurementConstant.BSCAN_HEIGHT_CM_MIN) || GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.BSCAN_HEIGHT_CM_MAX)) {
      return "${'error_message_invalid_range'.tr} (${MeasurementConstant.BSCAN_HEIGHT_CM_MIN}-${MeasurementConstant.BSCAN_HEIGHT_CM_MAX})";
    }
    return null;
  }

  validateHeightInFeet(String value) {
    if (!GetUtils.isNum(value) || GetUtils.isLowerThan(double.parse(value), MeasurementConstant.BSCAN_HEIGHT_FEET_MIN) || GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.BSCAN_HEIGHT_FEET_MAX)) {
      return "${'error_message_invalid_range'.tr} (${MeasurementConstant.BSCAN_HEIGHT_FEET_MIN}-${MeasurementConstant.BSCAN_HEIGHT_FEET_MAX})";
    }
    return null;
  }

  validateWeightInKg(String value) {
    if (!GetUtils.isNum(value) || GetUtils.isLowerThan(double.parse(value), MeasurementConstant.BSCAN_WEIGHT_KG_MIN) || GetUtils.isGreaterThan(double.parse(value), MeasurementConstant.BSCAN_WEIGHT_KG_MAX)) {
      return "${'error_message_invalid_range'.tr} (${MeasurementConstant.BSCAN_WEIGHT_KG_MIN}-${MeasurementConstant.BSCAN_WEIGHT_KG_MAX})";
    }
    return null;
  }

  nextPageSection() {
    bool error = false;
    bool rangeError = false;
    bool noSelectError = false;
    bool notValid = false;

    if(isValidInput()) {
      age.value = int.tryParse(ageEditTextController.text)??0;
      //page section 1
      if(pageSection.value == 1) {
        if(selecteedMenstrualCycleYear.value.value == null) {
          error = true;
          ShowToast.error('label_bscan_menstrual_period_age'.tr );
        } else if(selecteedMenstrualCycleYear.value.value! > age.value) {
          rangeError = true;
          ShowToast.error('label_bscan_menstrual_period_age'.tr );
        } else if(isMarried.value == null) {
          noSelectError = true;
          ShowToast.error('label_bscan_prf_married'.tr );
        } else if(isMarried.value! && hasChildren.value == null) {
          noSelectError = true;
          ShowToast.error('label_bscan_prf_have_children'.tr );
        } else if(isMarried.value! && hasChildren.value! && selecteedFirstChildBornYear.value.value == null) {
          error = true;
          ShowToast.error('label_bscan_prf_first_child_birth_age'.tr );
        } else if(isMarried.value! && hasChildren.value! && selecteedFirstChildBornYear.value.value! > age.value) {
          rangeError = true;
          ShowToast.error('label_bscan_prf_first_child_birth_age'.tr );
        } else if(isMarried.value! && hasChildren.value! && prfChildBreastFeed == null) {
          noSelectError = true;
          ShowToast.error('label_bscan_prf_child_breastfeed'.tr );
        } else if(prfBreastDisease == null) {
          noSelectError = true;
          ShowToast.error('label_bscan_prf_breast_disease'.tr );
        }
      }
      //page section 2
      if(pageSection.value == 2) {
        if(hasBCInFamilyMember.value == null) {
          noSelectError = true;
          ShowToast.error('label_bscan_bc_in_familly'.tr );
        } else if(hasBCInFamilyMember.value! && !frfMother && !frfSister && !frfDaughter && !frfMaternalAunt && !frfMaternalGrandmother && !frfPaternalAunt && !frfPaternalGrandmother) {
          noSelectError = true;
          ShowToast.error('error_message_please_select_one_family_member'.tr );
        }
      }
    } else {
      notValid = true;
    }

    if(rangeError){
      ShowToast.error('error_message_invalid_range'.tr);
    } else if(!error && !noSelectError && !notValid && pageSection.value < lastPageSection.value){
      pageSection.value++;
    }
  }

  previousPageSection() {
    pageSection.value--;
  }


  void sendMeasurement() {
    if (isLoading.isTrue) return;

    
    final isValid = screeningReportFormKey.currentState!.validate();
    if (!isValid) return;
    screeningReportFormKey.currentState!.save();

    isLoading.value = true;

    var measurement = MeasurementDTO(
        userId: customer.value.userId,
        measurementTypeCodeId: MeasurementType.BREAST_CANCER.value,
        measuredAt: dateController.text.isNotEmpty ? int.parse(dateController.text) : DateTime.now().millisecondsSinceEpoch,
        inputs: BscanInputDto(
          prfAge : double.parse(ageEditTextController.text),
          prfBmiHeights : double.parse(heightInFeetEditTextController.text)*12+double.parse(heightInInchEditTextController.text),
          prfBmiWeights : double.parse(weightEditTextController.text),
          prfMenstrualPeriodAge : selecteedMenstrualCycleYear.value.value,
          prfMarried : prfMarried ? 1: 0,
          prfHaveChildren : prfMarried && prfHaveChildren ? 1: 0,
          prfFirstChildBirthAge : prfMarried && prfHaveChildren ? selecteedFirstChildBornYear.value.value : 0.0,
          prfChildBreastFeed : prfMarried && prfHaveChildren && prfChildBreastFeed == true ? 1 : 0,
          prfBreastDisease : prfBreastDisease == true ? 1 : 0,
          frfMother : bcInFamilly && frfMother ? 1 : 0,
          frfSister : bcInFamilly && frfSister ? 1 : 0,
          frfDaughter : bcInFamilly && frfDaughter ? 1 : 0,
          frfMaternalAunt : bcInFamilly && frfMaternalAunt ? 1 : 0,
          frfMaternalGrandmother : bcInFamilly && frfMaternalGrandmother ? 1 : 0,
          frfPaternalAunt : bcInFamilly && frfPaternalAunt ? 1 : 0,
          frfPaternalGrandmother : bcInFamilly && frfPaternalGrandmother ? 1 : 0,
          bsaDiscomfortorArmpit : bsaDiscomfortorArmpit??0,
          bsaAbnormalSizeOrChangeShape : bsaAbnormalSizeOrChangeShape??0,
          bsaDimpledOrNippleLikeAnOrange : bsaDimpledOrNippleLikeAnOrange??0,
          bsaWoundOrUlcerNippleForTwoMonth : bsaWoundOrUlcerNippleForTwoMonth??0,
          bsaNippleTurnedInwardsNotOutwards : bsaNippleTurnedInwardsNotOutwards??0,
          bsaDischargeFromNippleAsBloodOrPus : bsaDischargeFromNippleAsBloodOrPus??0,
          bsaRednessTtLastTwoWeeks : bsaRednessTtLastTwoWeeks??0,
          bsaLumpOrSwelling : bsaLumpOrSwelling??0,
          bsaLumpOrSwellingInArmpit : bsaLumpOrSwellingInArmpit??0,
        ).toJson()
    );

    RLog.error(measurement.toJson());

    repository.sendData(ApiUrl.previewMeasurementUrl(), (measurement).toJson()).then((value) {
      isLoading.value = false;
      if (value != null) {
        measurement.result = value.result;
        // bool isValidMeasurementSelectionDetailsLogic = Get.isRegistered<MeasurementSelectionDetailsLogic>();
        // if(isValidMeasurementSelectionDetailsLogic) {
        //   Get.find<MeasurementSelectionDetailsLogic>().updateSelectedServiceTypeMeasurementStatus([measurement]);
        // }
        screeningReport.value = value;
        Get.offNamed('/screening_report_result_details', arguments: [
          ScreeningReportResultDetailsArgument(
              screeningReport: screeningReport.value, isAuto: false, measurementsWithResult: [measurement]
          )
        ]);
      } else {
        ShowToast.error('error_massage_something_wrong'.tr);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    dateController.dispose();
    ageEditTextController.dispose();
    heightInFeetEditTextController.dispose();
    heightInInchEditTextController.dispose();
    weightEditTextController.dispose();
  }


  canBack() {
    return pageSection.value <= 1;
  }

  void resetMasterDataYearList() {
    age.value = int.tryParse(ageEditTextController.text)??0;
    if(age.value <=8) {
      age.value = 8;
    }
    selecteedMenstrualCycleYear.value = MasterDataDTO();
    selecteedFirstChildBornYear.value = MasterDataDTO();
  }

}
