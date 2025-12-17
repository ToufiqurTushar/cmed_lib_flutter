import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/common/widget/basic_app_bar.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_button_yes_no.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_checkbox.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_dropdown_select.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_radio_button.dart';
import 'package:cmed_lib_flutter/page/health_screening/repository/screening_report_repository.dart';
import 'package:cmed_lib_flutter/page/health_screening/health_screening_home_i18n.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/bscan/bscan_input_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/constant/measurementconstants.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/helper/text_utils.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_text_field.dart';
import 'package:cmed_lib_flutter/common/widget/cmed_white_elevated_button.dart';

import '../../../../../../common/enum/yes_no_enum.dart';


class BScanInputView extends RapidView<BScanInputLogic> {
  static String routeName = '/bscan_input_page';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(controller.canBack()) {
          return true;
        }
        controller.previousPageSection();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: BasicAppBar('label_breast_cancer_screening'.tr),
          body: SafeArea(
            child: Form(
              key: controller.screeningReportFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            shadowColor: Theme.of(context).primaryColor,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Obx(
                                    ()=> Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    //section 1
                                    Visibility(
                                      visible: controller.pageSection.value == 1,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'label_age'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CMEDTextField('label_age'.tr, keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false), inputFormatters: [FilteringTextInputFormatter.digitsOnly], textEditingController: controller.ageEditTextController, autovalidateMode: AutovalidateMode.onUserInteraction, onValidator: (value) {
                                            if(!controller.isValidAgeRange(value)){
                                              return "${'error_message_invalid_range'.tr} (${MeasurementConstant.BSCAN_AGE_MIN}-${MeasurementConstant.BSCAN_AGE_MAX})";
                                            }
                                            return null;
                                          }, onChanged: (value){
                                            if (controller.isValidAgeRange(value)) {
                                              Future.delayed(Duration.zero, () async {
                                                controller.resetMasterDataYearList();
                                              });
                                            }
                                          }),
                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Text(
                                            'label_bmi'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CMEDTextField('label_height_feet'.tr, keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false), inputFormatters: [FilteringTextInputFormatter.digitsOnly], textEditingController: controller.heightInFeetEditTextController, autovalidateMode: AutovalidateMode.onUserInteraction, onSaved: (value) {}, onValidator: (value) {
                                                  return controller.validateHeightInFeet(value);
                                                }),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: CMEDTextField('label_height_inch'.tr, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))], textEditingController: controller.heightInInchEditTextController, autovalidateMode: AutovalidateMode.onUserInteraction, onSaved: (value) {}, onValidator: (value) {
                                                  return controller.validateHeightInInch(value);
                                                }),
                                              ),
                                            ],
                                          ),
                                          CMEDTextField('input_label_input_weight_kg'.tr, keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))], textEditingController: controller.weightEditTextController, autovalidateMode: AutovalidateMode.onUserInteraction, onSaved: (value) {}, onValidator: (value) {
                                            return controller.validateWeightInKg(value);
                                          }),
                                          const SizedBox(
                                            height: 16,
                                          ),


                                          CMEDDropdownSelect(
                                            List.generate(controller.age.value-7, (i) => MasterDataDTO(labelEn: "${i+8} years",labelBn: "${Utils.getDigitBanglaFromEnglish((i+8).toString())} বছর", value: i+8)),
                                            label: 'label_bscan_menstrual_period_age'.tr,
                                            item: controller.selecteedMenstrualCycleYear.value,
                                            onItemSelected: (data) {
                                              controller.selecteedMenstrualCycleYear.value = data;
                                            },
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Text(
                                            'label_bscan_prf_married'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          CMEDRadioButton(
                                                (data) {
                                              controller.isMarried.value = data.value == YesNoEnum.YES.value ? true : false;
                                              controller.prfMarried = controller.isMarried.value!;
                                              controller.hasChildren.value = null;
                                            },
                                            controller.yesNoList,
                                            isHorizontal: true,
                                            selectedItemPosition: controller.isMarried.value == true ? 0 : controller.isMarried.value == false ? 1 : null,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),

                                          Visibility(
                                            visible: controller.isMarried.value == true,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'label_bscan_prf_have_children'.tr,
                                                  style: CMEDTextUtils.inputTextLabelStyle,
                                                ),
                                                CMEDRadioButton(
                                                      (data) {
                                                    controller.hasChildren.value = data.value == YesNoEnum.YES.value ? true : false;
                                                    controller.prfHaveChildren = controller.hasChildren.value!;
                                                    controller.selecteedFirstChildBornYear.value = MasterDataDTO();
                                                    controller.prfChildBreastFeed = null;
                                                  },
                                                  controller.yesNoList,
                                                  isHorizontal: true,
                                                  selectedItemPosition: controller.hasChildren.value == true ? 0: controller.hasChildren.value == false ? 1 : null,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),

                                              ],
                                            ),
                                          ),



                                          Visibility(
                                            visible: controller.isMarried.value == true && controller.hasChildren.value == true,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CMEDDropdownSelect(
                                                  List.generate(controller.age.value-7, (i) => MasterDataDTO(labelEn: "${i+8} years",labelBn: "${Utils.getDigitBanglaFromEnglish((i+8).toString())} বছর", value: i+8)),
                                                  label: 'label_bscan_prf_first_child_birth_age'.tr,
                                                  item: controller.selecteedFirstChildBornYear.value,
                                                  onItemSelected: (data) {
                                                    controller.selecteedFirstChildBornYear.value = data;
                                                  },
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),

                                                Text(
                                                  'label_bscan_prf_child_breastfeed'.tr,
                                                  style: CMEDTextUtils.inputTextLabelStyle,
                                                ),
                                                CMEDRadioButton(
                                                      (data) {
                                                    controller.prfChildBreastFeed = data.value == YesNoEnum.YES.value ? true : false;
                                                  },
                                                  controller.yesNoList,
                                                  isHorizontal: true,
                                                  selectedItemPosition: controller.prfChildBreastFeed == true ? 0: controller.prfChildBreastFeed == false ? 1 : null,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),


                                          Text(
                                            'label_bscan_prf_breast_disease'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          CMEDRadioButton(
                                                (data) {
                                              controller.prfBreastDisease = data.value == YesNoEnum.YES.value ? true : false;
                                            },
                                            controller.yesNoList,
                                            isHorizontal: true,
                                            selectedItemPosition: controller.prfBreastDisease == true ? 0: controller.prfBreastDisease == false ? 1 : null,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 2
                                    Visibility(
                                      visible: controller.pageSection.value == 2,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'label_bscan_bc_in_familly'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          CMEDRadioButton(
                                                (data) {
                                              controller.hasBCInFamilyMember.value = data.value == YesNoEnum.YES.value ? true : false;
                                              controller.bcInFamilly = controller.hasBCInFamilyMember.value!;
                                              controller.frfMother = false;
                                              controller.frfSister = false;
                                              controller.frfDaughter = false;
                                              controller.frfMaternalAunt = false;
                                              controller.frfMaternalGrandmother = false;
                                              controller.frfPaternalAunt = false;
                                              controller.frfPaternalGrandmother = false;
                                            },
                                            controller.yesNoList,
                                            isHorizontal: true,
                                            selectedItemPosition: controller.hasBCInFamilyMember.value == true ? 0 : controller.hasBCInFamilyMember.value == false ? 1 : null,
                                          ),
                                          Visibility(
                                            visible: controller.hasBCInFamilyMember.value == true,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfMother,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[0].labelBn : controller.familyMemberRelationList[0].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfMother = checked;
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfSister,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[1].labelBn : controller.familyMemberRelationList[1].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfSister = checked;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfDaughter,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[2].labelBn : controller.familyMemberRelationList[2].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfDaughter = checked;
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfMaternalAunt,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[3].labelBn : controller.familyMemberRelationList[3].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfMaternalAunt = checked;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfMaternalGrandmother,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[4].labelBn : controller.familyMemberRelationList[4].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfMaternalGrandmother = checked;
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfPaternalAunt,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[5].labelBn : controller.familyMemberRelationList[5].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfPaternalAunt = checked;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: CMEDCheckbox(
                                                        controller.frfPaternalGrandmother,
                                                        isMarqueeTitle: true,
                                                        label: (Utils.isLocaleBn()) ? controller.familyMemberRelationList[6].labelBn : controller.familyMemberRelationList[6].labelEn,
                                                        textColor: Theme.of(context).primaryColor,
                                                        textSize: 14,
                                                        onChecked: (checked) {
                                                          controller.frfPaternalGrandmother = checked;
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 3
                                    Visibility(
                                      visible: controller.pageSection.value == 3,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_1.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_discomfort_or_armpit'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaDiscomfortorArmpit = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaDiscomfortorArmpit,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 4
                                    Visibility(
                                      visible: controller.pageSection.value == 4,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_2.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_abnormal_size_or_change_shape'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaAbnormalSizeOrChangeShape = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaAbnormalSizeOrChangeShape,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 5
                                    Visibility(
                                      visible: controller.pageSection.value == 5,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_3.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_dimpled_or_nipple_like_an_orange'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaDimpledOrNippleLikeAnOrange = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaDimpledOrNippleLikeAnOrange,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 6
                                    Visibility(
                                      visible: controller.pageSection.value == 6,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_4.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_wound_or_ulcer_nipple_for_two_month'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaWoundOrUlcerNippleForTwoMonth = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaWoundOrUlcerNippleForTwoMonth,
                                          ),

                                        ],
                                      ),
                                    ),


                                    //section 7
                                    Visibility(
                                      visible: controller.pageSection.value == 7,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_5.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_nipple_turned_inwards_not_outwards'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaNippleTurnedInwardsNotOutwards = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaNippleTurnedInwardsNotOutwards,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 8
                                    Visibility(
                                      visible: controller.pageSection.value == 8,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_6.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_discharge_from_nipple_as_blood_or_pus'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaDischargeFromNippleAsBloodOrPus = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaDischargeFromNippleAsBloodOrPus,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 9
                                    Visibility(
                                      visible: controller.pageSection.value == 9,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_7.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_redness_at_last_two_weeks'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaRednessTtLastTwoWeeks = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaRednessTtLastTwoWeeks,
                                          ),

                                        ],
                                      ),
                                    ),


                                    //section 10
                                    Visibility(
                                      visible: controller.pageSection.value == 10,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_8.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_lump_or_swelling'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaLumpOrSwelling = data;
                                              Future.delayed(const Duration(milliseconds: 50), () async {
                                                controller.nextPageSection();
                                              });
                                            },
                                            selectedValue: controller.bsaLumpOrSwelling,
                                          ),
                                        ],
                                      ),
                                    ),


                                    //section 11
                                    Visibility(
                                      visible: controller.pageSection.value == 11,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurement/bscan_measurement_image_9.png",
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'label_bscan_bsa_lump_or_swelling_in_armpit'.tr,
                                            style: CMEDTextUtils.inputTextLabelStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          CMEDButtonYesNo(
                                                (data) {
                                              controller.bsaLumpOrSwellingInArmpit = data;
                                              controller.swellingInArmpit.value = data;
                                            },
                                            selectedValue: controller.bsaLumpOrSwellingInArmpit,
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
                        Stack(
                          children: [
                            Obx(
                                  ()=> Visibility(
                                visible: controller.pageSection.value == 1 || controller.pageSection.value == 2 || (controller.pageSection.value == controller.lastPageSection.value && controller.swellingInArmpit.value != null),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: CMEDWhiteElevatedButton(
                                      'label_next'.tr,
                                          () => {
                                        if(controller.pageSection.value == controller.lastPageSection.value) {
                                          controller.sendMeasurement()
                                        } else {
                                          controller.nextPageSection()
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              return Visibility(
                                  visible: controller.isLoading.value,
                                  child: const Center(
                                      child: CircularProgressIndicator()
                                  )
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

    Get.put(ScreeningReportRepository());
    Get.put(
        BScanInputLogic(repository: Get.find<ScreeningReportRepository>()));
  }
}
