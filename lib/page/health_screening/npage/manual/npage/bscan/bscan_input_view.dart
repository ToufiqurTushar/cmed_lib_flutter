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
import '../../../../../../common/widget/cmed_dropdown_view.dart';


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
          backgroundColor: controller.isThemeV2?Colors.transparent:null,
          appBar: controller.isNestedRoute? null: controller.isThemeV2?BasicAppBarV2('label_breast_cancer_screening'.tr):BasicAppBar('label_breast_cancer_screening'.tr),
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
                                            color: Colors.white,
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
    return {
      "en_US": {
        "label_breast_cancer": "Breast Cancer",
        "label_breast_cancer_screening": "Breast Cancer Screening",
        "error_message_please_select": "Please, select",
        "error_message_please_select_one_family_member": "Select at least one family member",
        "label_height_feet": "Height (Feet)",
        "label_height_inch": "Height (Inch)",
        "label_bscan_menstrual_period_age": "When did you experience your first menstrual cycle?",
        "label_bscan_prf_married": "Are you married?",
        "label_bscan_prf_have_children": "Do you have children’s?",
        "label_bscan_prf_first_child_birth_age": "How old were you when your first child was born?",
        "label_bscan_prf_child_breastfeed": "Have you breastfed your child?",
        "label_bscan_prf_breast_disease": "Have you ever been diagnosed with any breast disease?",
        "label_bscan_bc_in_familly": "Has anyone in your family ever been diagnosed with breast cancer?",
        "label_bscan_bsa_discomfort_or_armpit": "Do you have any pain or discomfort in your breast or armpit that has been there for a long time?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "Have you noticed an unusual increase in breast size or any unusual changes in shape?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "Is the skin of the breast or the skin as thick as an orange peel?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "Are there any sores or sores on the skin or nipples that have not healed for a long time (more than 2 months)?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "Are the nipples abnormally inverted and not protruding?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "Does the nipple discharge blood, mucus, pus or any other type of fluid?",
        "label_bscan_bsa_redness_at_last_two_weeks": "Is there any redness of the breast skin or skin that has lasted for at least 2 weeks? (Symptoms of breast inflammation)",
        "label_bscan_bsa_lump_or_swelling": "Have you felt any lumps in your breasts?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "Have you felt any lumps under your armpits?",
        "label_low_risk": "Low Risk",
        "label_moderate_risk": "Moderate Risk",
        "label_high_risk": "High Risk",
        "label_very_high_risk": "Very High Risk"
      },
      "bn_BD": {
        "label_breast_cancer": "স্তন ক্যান্সার",
        "label_breast_cancer_screening": "স্তন ক্যান্সার স্ক্রিনিং",
        "error_message_please_select": "অনুগ্রহ করে নির্বাচন করুন",
        "error_message_please_select_one_family_member": "পরিবারের অন্তত একজন সদস্যকে নির্বাচন করুন",
        "label_height_feet": "উচ্চতা (ফুট)",
        "label_height_inch": "উচ্চতা (ইঞ্চি)",
        "label_bscan_menstrual_period_age": "আপনার প্রথম মাসিক কবে হয়েছিল?",
        "label_bscan_prf_married": "আপনি কি বিবাহিত?",
        "label_bscan_prf_have_children": "আপনার কি সন্তান আছে?",
        "label_bscan_prf_first_child_birth_age": "আপনার প্রথম সন্তান জন্মের সময় আপনার বয়স কত ছিল?",
        "label_bscan_prf_child_breastfeed": "আপনি কি আপনার সন্তানকে বুকের দুধ খাইয়েছেন?",
        "label_bscan_prf_breast_disease": "আপনার কি কখনো কোনো স্তন রোগ ধরা পড়েছে?",
        "label_bscan_bc_in_familly": "আপনার পরিবারের কারো কি কখনো স্তন ক্যান্সার ধরা পড়েছে?",
        "label_bscan_bsa_discomfort_or_armpit": "আপনার কি স্তনে বা বগলে দীর্ঘদিন ধরে কোনো ব্যথা বা অস্বস্তি রয়েছে?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "আপনি কি স্তনের আকারে অস্বাভাবিক বৃদ্ধি বা আকৃতিতে কোনো অস্বাভাবিক পরিবর্তন লক্ষ্য করেছেন?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "স্তনের চামড়া বা চামড়া কি কমলার খোসার মতো পুরু?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "ত্বকে বা স্তনবৃন্তে কি এমন কোনো ঘা বা ক্ষত আছে যা অনেকদিন ধরে (২ মাসের বেশি) সেরে ওঠেনি?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "স্তনবৃন্তগুলো কি অস্বাভাবিকভাবে ভেতরের দিকে ঢোকানো এবং বাইরের দিকে প্রসারিত নয়?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "স্তনবৃন্ত থেকে কি রক্ত, শ্লেষ্মা, পুঁজ বা অন্য কোনো ধরনের তরল নিঃসৃত হয়?",
        "label_bscan_bsa_redness_at_last_two_weeks": "স্তনের ত্বকে কি কোনো লালচে ভাব আছে যা অন্তত ২ সপ্তাহ ধরে রয়েছে? (স্তনের প্রদাহের লক্ষণ)",
        "label_bscan_bsa_lump_or_swelling": "আপনার স্তনে কি কোনো চাকা বা পিণ্ড অনুভব করেছেন?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "আপনার বগলের নিচে কি কোনো পিণ্ড অনুভব করেছেন?",
        "label_low_risk": "কম ঝুঁকি",
        "label_moderate_risk": "মাঝারি ঝুঁকি",
        "label_high_risk": "উচ্চ ঝুঁকি",
        "label_very_high_risk": "অত্যন্ত উচ্চ ঝুঁকি"
      },
      "kn_IN": {
        "label_breast_cancer": "ಸ್ತನ ಕ್ಯಾನ್ಸರ್",
        "label_breast_cancer_screening": "ಸ್ತನ ಕ್ಯಾನ್ಸರ್ ತಪಾಸಣೆ",
        "error_message_please_select": "ದಯವಿಟ್ಟು ಆಯ್ಕೆಮಾಡಿ",
        "error_message_please_select_one_family_member": "ಕನಿಷ್ಠ ಒಬ್ಬ ಕುಟುಂಬ ಸದಸ್ಯರನ್ನು ಆಯ್ಕೆಮಾಡಿ",
        "label_height_feet": "ಎತ್ತರ (ಅಡಿ)",
        "label_height_inch": "ಎತ್ತರ (ಇಂಚು)",
        "label_bscan_menstrual_period_age": "ನಿಮ್ಮ ಮೊದಲ ಮುಟ್ಟಿನ ಚಕ್ರ ಯಾವಾಗ ಆರಂಭವಾಯಿತು?",
        "label_bscan_prf_married": "ನೀವು ಮದುವೆಯಾಗಿದ್ದೀರಾ?",
        "label_bscan_prf_have_children": "ನಿಮಗೆ ಮಕ್ಕಳಿದ್ದಾರೆಯೇ?",
        "label_bscan_prf_first_child_birth_age": "ನಿಮ್ಮ ಮೊದಲ ಮಗು ಜನಿಸಿದಾಗ ನಿಮ್ಮ ವಯಸ್ಸು ಎಷ್ಟು?",
        "label_bscan_prf_child_breastfeed": "ನಿಮ್ಮ ಮಗುವಿಗೆ ನೀವು ಎದೆಹಾಲು ಕುಡಿಸಿದ್ದೀರಾ?",
        "label_bscan_prf_breast_disease": "ನಿಮಗೆ ಎಂದಾದರೂ ಸ್ತನ ಕಾಯಿಲೆ ಇರುವುದು ಪತ್ತೆಯಾಗಿದೆಯೇ?",
        "label_bscan_bc_in_familly": "ನಿಮ್ಮ ಕುಟುಂಬದಲ್ಲಿ ಯಾರಿಗಾದರೂ ಸ್ತನ ಕ್ಯಾನ್ಸರ್ ಇರುವುದು ಪತ್ತೆಯಾಗಿದೆಯೇ?",
        "label_bscan_bsa_discomfort_or_armpit": "ನಿಮ್ಮ ಎದೆ ಅಥವಾ ಕಂಕುಳಲ್ಲಿ ದೀರ್ಘಕಾಲದಿಂದ ಇರುವ ಯಾವುದೇ ನೋವು ಅಥವಾ ಅಸ್ವಸ್ಥತೆ ಇದೆಯೇ?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "ಸ್ತನದ ಗಾತ್ರದಲ್ಲಿ ಅಸಾಮಾನ್ಯ ಹೆಚ್ಚಳ ಅಥವಾ ಆಕಾರದಲ್ಲಿ ಯಾವುದೇ ಅಸಾಮಾನ್ಯ ಬದಲಾವಣೆಗಳನ್ನು ನೀವು ಗಮನಿಸಿದ್ದೀರಾ?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "ಸ್ತನದ ಚರ್ಮ ಅಥವಾ ಕಿತ್ತಳೆ ಸಿಪ್ಪೆಯಷ್ಟು ದಪ್ಪವಾಗಿದೆಯೇ?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "ಚರ್ಮ ಅಥವಾ ಮೊಲೆತೊಟ್ಟುಗಳ ಮೇಲೆ ದೀರ್ಘಕಾಲ (2 ತಿಂಗಳಿಗಿಂತ ಹೆಚ್ಚು) ಗುಣವಾಗದ ಯಾವುದೇ ಹುಣ್ಣುಗಳು ಅಥವಾ ಹುಣ್ಣುಗಳು ಇವೆಯೇ?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "ಮೊಲೆತೊಟ್ಟುಗಳು ಅಸಹಜವಾಗಿ ತಲೆಕೆಳಗಾಗಿವೆಯೇ ಮತ್ತು ಚಾಚಿಕೊಂಡಿಲ್ಲವೇ?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "ಮೊಲೆತೊಟ್ಟುಗಳಿಂದ ರಕ್ತ, ಲೋಳೆ, ಕೀವು ಅಥವಾ ಯಾವುದೇ ರೀತಿಯ ದ್ರವ ಸ್ರವಿಸುತ್ತದೆಯೇ?",
        "label_bscan_bsa_redness_at_last_two_weeks": "ಸ್ತನದ ಚರ್ಮ ಅಥವಾ ಚರ್ಮದ ಕೆಂಪು ಬಣ್ಣವು ಕನಿಷ್ಠ 2 ವಾರಗಳವರೆಗೆ ಇದೆಯೇ? (ಸ್ತನ ಉರಿಯೂತದ ಲಕ್ಷಣಗಳು)",
        "label_bscan_bsa_lump_or_swelling": "ನಿಮ್ಮ ಸ್ತನಗಳಲ್ಲಿ ಯಾವುದೇ ಗಡ್ಡೆಗಳು ಕಂಡುಬಂದಿವೆಯೇ?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "ನಿಮ್ಮ ಕಂಕುಳಲ್ಲಿ ಯಾವುದೇ ಉಂಡೆಗಳು ಕಾಣಿಸಿಕೊಂಡಿವೆಯೇ?",
        "label_low_risk": "ಕಡಿಮೆ ಅಪಾಯ",
        "label_moderate_risk": "ಮಧ್ಯಮ ಅಪಾಯ",
        "label_high_risk": "ಹೆಚ್ಚಿನ ಅಪಾಯ",
        "label_very_high_risk": "ತುಂಬಾ ಹೆಚ್ಚಿನ ಅಪಾಯ"
      },
      "hi_IN": {
        "label_breast_cancer": "स्तन कैंसर",
        "label_breast_cancer_screening": "स्तन कैंसर की जांच",
        "error_message_please_select": "कृपया चयन करें",
        "error_message_please_select_one_family_member": "कम से कम एक परिवार के सदस्य का चयन करें",
        "label_height_feet": "ऊंचाई (फीट)",
        "label_height_inch": "ऊंचाई (इंच)",
        "label_bscan_menstrual_period_age": "आपका पहला मासिक धर्म कब शुरू हुआ?",
        "label_bscan_prf_married": "क्या आप विवाहित हैं?",
        "label_bscan_prf_have_children": "क्या आपके बच्चे हैं?",
        "label_bscan_prf_first_child_birth_age": "जब आपका पहला बच्चा पैदा हुआ तब आपकी उम्र कितनी थी?",
        "label_bscan_prf_child_breastfeed": "क्या आपने अपने बच्चे को स्तनपान कराया है?",
        "label_bscan_prf_breast_disease": "क्या आपको कभी स्तन रोग का निदान हुआ है?",
        "label_bscan_bc_in_familly": "क्या आपके परिवार में किसी को स्तन कैंसर का निदान हुआ है?",
        "label_bscan_bsa_discomfort_or_armpit": "क्या आपकी छाती या बगल में लंबे समय से कोई दर्द या असुविधा है?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "क्या आपने स्तन के आकार में कोई असामान्य वृद्धि या आकार में कोई असामान्य बदलाव देखा है?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "क्या स्तन की त्वचा या निप्पल संतरे के छिलके जैसी मोटी हो गई है?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "क्या त्वचा या निप्पल पर लंबे समय से (2 महीने से अधिक) कोई घाव या अल्सर है जो ठीक नहीं हो रहा है?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "क्या निप्पल असामान्य रूप से अंदर की ओर मुड़े हुए हैं और बाहर की ओर नहीं निकले हैं?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "क्या निप्पल से रक्त, बलगम, मवाद या किसी भी प्रकार का तरल पदार्थ निकलता है?",
        "label_bscan_bsa_redness_at_last_two_weeks": "क्या स्तन की त्वचा या त्वचा का लाल होना कम से कम 2 सप्ताह से है? (स्तन में सूजन के लक्षण)",
        "label_bscan_bsa_lump_or_swelling": "क्या आपको अपने स्तनों में कोई गांठ महसूस हुई है?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "क्या आपको अपनी बगल में कोई गांठ महसूस हुई है?",
        "label_low_risk": "कम जोखिम",
        "label_moderate_risk": "मध्यम जोखिम",
        "label_high_risk": "उच्च जोखिम",
        "label_very_high_risk": "बहुत उच्च जोखिम"
      },
      "ta_IN": {
        "label_breast_cancer": "மார்பகப் புற்றுநோய்",
        "label_breast_cancer_screening": "மார்பகப் புற்றுநோய் பரிசோதனை",
        "error_message_please_select": "தயவுசெய்து தேர்ந்தெடுக்கவும்",
        "error_message_please_select_one_family_member": "குறைந்தது ஒரு குடும்ப உறுப்பினரைத் தேர்ந்தெடுக்கவும்",
        "label_height_feet": "உயரம் (அடி)",
        "label_height_inch": "உயரம் (அங்குலம்)",
        "label_bscan_menstrual_period_age": "உங்கள் முதல் மாதவிடாய் சுழற்சி எப்போது தொடங்கியது?",
        "label_bscan_prf_married": "நீங்கள் திருமணமானவரா?",
        "label_bscan_prf_have_children": "உங்களுக்கு குழந்தைகள் உள்ளனவா?",
        "label_bscan_prf_first_child_birth_age": "உங்கள் முதல் குழந்தை பிறந்தபோது உங்கள் வயது என்ன?",
        "label_bscan_prf_child_breastfeed": "நீங்கள் உங்கள் குழந்தைக்கு தாய்ப்பால் கொடுத்தீர்களா?",
        "label_bscan_prf_breast_disease": "உங்களுக்கு எப்போதாவது மார்பக நோய் இருப்பது கண்டறியப்பட்டுள்ளதா?",
        "label_bscan_bc_in_familly": "உங்கள் குடும்பத்தில் யாருக்காவது மார்பகப் புற்றுநோய் இருப்பது கண்டறியப்பட்டுள்ளதா?",
        "label_bscan_bsa_discomfort_or_armpit": "உங்கள் மார்பு அல்லது அக்குளில் நீண்ட காலமாக ஏதேனும் வலி அல்லது அசௌகரியம் உள்ளதா?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "மார்பகத்தின் அளவில் அசாதாரண அதிகரிப்பு அல்லது வடிவத்தில் ஏதேனும் அசாதாரண மாற்றங்களை நீங்கள் கவனித்துள்ளீர்களா?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "மார்பகத்தின் தோல் அல்லது முலைக்காம்பு ஆரஞ்சு பழத்தோல் போன்று தடிமனாக உள்ளதா?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "தோல் அல்லது முலைக்காம்பில் நீண்ட காலமாக (2 மாதங்களுக்கு மேல்) ஆறாத ஏதேனும் காயம் அல்லது புண் உள்ளதா?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "முலைக்காம்புகள் அசாதாரணமாக உள்நோக்கி திரும்பி, வெளிப்புறமாக நீட்டாமல் உள்ளனவா?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "முலைக்காம்பிலிருந்து இரத்தம், சளி, சீழ் அல்லது ஏதேனும் திரவம் வெளியேறுகிறதா?",
        "label_bscan_bsa_redness_at_last_two_weeks": "மார்பகத் தோல் அல்லது தோலின் சிவத்தல் குறைந்தது 2 வாரங்களாக உள்ளதா? (மார்பக அழற்சியின் அறிகுறிகள்)",
        "label_bscan_bsa_lump_or_swelling": "உங்கள் மார்பகங்களில் ஏதேனும் கட்டிகள் உள்ளதா?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "உங்கள் அக்குளில் ஏதேனும் கட்டிகள் உள்ளதா?",
        "label_low_risk": "குறைந்த ஆபத்து",
        "label_moderate_risk": "மிதமான ஆபத்து",
        "label_high_risk": "அதிக ஆபத்து",
        "label_very_high_risk": "மிக அதிக ஆபத்து"
      },
      "te_IN": {
        "label_breast_cancer": "రొమ్ము క్యాన్సర్",
        "label_breast_cancer_screening": "రొమ్ము క్యాన్సర్ స్క్రీనింగ్",
        "error_message_please_select": "దయచేసి ఎంచుకోండి",
        "error_message_please_select_one_family_member": "కనీసం ఒక కుటుంబ సభ్యుడిని ఎంచుకోండి",
        "label_height_feet": "ఎత్తు (అడుగులు)",
        "label_height_inch": "ఎత్తు (అంగుళాలు)",
        "label_bscan_menstrual_period_age": "మీ మొదటి రుతుచక్రం ఎప్పుడు ప్రారంభమైంది?",
        "label_bscan_prf_married": "మీకు వివాహమైందా?",
        "label_bscan_prf_have_children": "మీకు పిల్లలు ఉన్నారా?",
        "label_bscan_prf_first_child_birth_age": "మీ మొదటి బిడ్డ జన్మించినప్పుడు మీ వయస్సు ఎంత?",
        "label_bscan_prf_child_breastfeed": "మీరు మీ బిడ్డకు తల్లిపాలు ఇచ్చారా?",
        "label_bscan_prf_breast_disease": "మీకు ఎప్పుడైనా రొమ్ము వ్యాధి ఉన్నట్లు నిర్ధారణ అయిందా?",
        "label_bscan_bc_in_familly": "మీ కుటుంబంలో ఎవరికైనా రొమ్ము క్యాన్సర్ ఉన్నట్లు నిర్ధారణ అయిందా?",
        "label_bscan_bsa_discomfort_or_armpit": "మీ ఛాతీ లేదా చంకలో చాలా కాలంగా ఏదైనా నొప్పి లేదా అసౌకర్యం ఉందా?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "రొమ్ము పరిమాణంలో అసాధారణ పెరుగుదల లేదా ఆకారంలో ఏదైనా అసాధారణ మార్పును మీరు గమనించారా?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "రొమ్ము చర్మం లేదా మామిడి చర్మంలా మందంగా ఉందా?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "చర్మం లేదా మామిడికాయపై ఎక్కువ కాలంగా (2 నెలలకు పైగా) మానని ఏదైనా గాయం లేదా పుండు ఉందా?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "మామిడికాయలు అసాధారణంగా లోపలికి తిరిగి, బయటకు పొడుచుకుని కనిపించకుండా ఉన్నాయా?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "మామిడికాయల నుండి రక్తం, శ్లేష్మం, చీము లేదా ఏదైనా ద్రవం కారుతుందా?",
        "label_bscan_bsa_redness_at_last_two_weeks": "రొమ్ము చర్మం లేదా చర్మం ఎర్రగా మారడం కనీసం 2 వారాలుగా ఉందా? (రొమ్ము వాపు లక్షణాలు)",
        "label_bscan_bsa_lump_or_swelling": "మీ రొమ్ముల్లో ఏవైనా గడ్డలు ఉన్నాయా?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "మీ చంకలో ఏవైనా గడ్డలు ఉన్నాయా?",
        "label_low_risk": "తక్కువ ప్రమాదం",
        "label_moderate_risk": "మధ్యస్థ ప్రమాదం",
        "label_high_risk": "అధిక ప్రమాదం",
        "label_very_high_risk": "చాలా ఎక్కువ ప్రమాదం"
      },
      "or_IN": {
        "label_breast_cancer": "ସ୍ତନ କର୍କଟ",
        "label_breast_cancer_screening": "ସ୍ତନ କର୍କଟ ଯାଞ୍ଚ",
        "error_message_please_select": "ଦୟାକରି ଚୟନ କରନ୍ତୁ",
        "error_message_please_select_one_family_member": "ଅତି କମରେ ଜଣେ ପରିବାର ସଦସ୍ୟଙ୍କୁ ଚୟନ କରନ୍ତୁ",
        "label_height_feet": "ଉଚ୍ଚତା (ଫୁଟ)",
        "label_height_inch": "ଉଚ୍ଚତା (ଇଞ୍ଚ)",
        "label_bscan_menstrual_period_age": "ଆପଣଙ୍କର ପ୍ରଥମ ଋତୁସ୍ରାବ କେବେ ଆରମ୍ଭ ହୋଇଥିଲା?",
        "label_bscan_prf_married": "ଆପଣ ବିବାହିତ କି?",
        "label_bscan_prf_have_children": "ଆପଣଙ୍କର ପିଲା ଅଛନ୍ତି କି?",
        "label_bscan_prf_first_child_birth_age": "ଆପଣଙ୍କର ପ୍ରଥମ ପିଲା ଜନ୍ମ ହେବା ସମୟରେ ଆପଣଙ୍କ ବୟସ କେତେ ଥିଲା?",
        "label_bscan_prf_child_breastfeed": "ଆପଣ ଆପଣଙ୍କ ପିଲାକୁ ସ୍ତନ୍ୟପାନ କରାଇଥିଲେ କି?",
        "label_bscan_prf_breast_disease": "ଆପଣଙ୍କୁ କେବେ ସ୍ତନ ରୋଗ ଥିବା ନିର୍ଣ୍ଣୟ କରାଯାଇଛି କି?",
        "label_bscan_bc_in_familly": "ଆପଣଙ୍କ ପରିବାରରେ କାହାରିକୁ ସ୍ତନ କର୍କଟ ଥିବା ନିର୍ଣ୍ଣୟ କରାଯାଇଛି କି?",
        "label_bscan_bsa_discomfort_or_armpit": "ଆପଣଙ୍କ ଛାତି କିମ୍ବା କାଖରେ ଦୀର୍ଘ ସମୟ ଧରି କୌଣସି ଯନ୍ତ୍ରଣା କିମ୍ବା ଅସୁବିଧା ଅଛି କି?",
        "label_bscan_bsa_abnormal_size_or_change_shape": "ଆପଣ ସ୍ତନର ଆକାରରେ ଅସାମାନ୍ୟ ବୃଦ୍ଧି କିମ୍ବା ଆକୃତିରେ କୌଣସି ଅସାମାନ୍ୟ ପରିବର୍ତ୍ତନ ଲକ୍ଷ୍ୟ କରିଛନ୍ତି କି?",
        "label_bscan_bsa_dimpled_or_nipple_like_an_orange": "ସ୍ତନର ଚର୍ମ କିମ୍ବା ସ୍ତନବନ୍ଦ ଏକ କମଳା ଚୋପା ପରି ମୋଟା ହୋଇଛି କି?",
        "label_bscan_bsa_wound_or_ulcer_nipple_for_two_month": "ଚର୍ମ କିମ୍ବା ସ୍ତନବନ୍ଦରେ ଦୀର୍ଘ ସମୟ ଧରି (2 ମାସରୁ ଅଧିକ) ଭଲ ହେଉନଥିବା କୌଣସି ଘା କିମ୍ବା ଅଲସର ଅଛି କି?",
        "label_bscan_bsa_nipple_turned_inwards_not_outwards": "ସ୍ତନବନ୍ଦଗୁଡ଼ିକ ଅସ୍ୱାଭାବିକ ଭାବରେ ଭିତରକୁ ମୁହଁ କରିଛି ଏବଂ ବାହାରକୁ ବାହାରି ନାହିଁ କି?",
        "label_bscan_bsa_discharge_from_nipple_as_blood_or_pus": "ସ୍ତନବନ୍ଦରୁ ରକ୍ତ, ଶ୍ଳେଷ୍ମା, ପୁଜ କିମ୍ବା କୌଣସି ପ୍ରକାରର ତରଳ ପଦାର୍ଥ ବାହାରୁଛି କି?",
        "label_bscan_bsa_redness_at_last_two_weeks": "ସ୍ତନର ଚର୍ମ କିମ୍ବା ଚର୍ମର ଲାଲିମା ଅତି କମରେ 2 ସପ୍ତାହ ଧରି ଅଛି କି? (ସ୍ତନର ପ୍ରଦାହର ଲକ୍ଷଣ)",
        "label_bscan_bsa_lump_or_swelling": "ଆପଣଙ୍କ ସ୍ତନରେ କୌଣସି ଗାଠି ଅଛି କି?",
        "label_bscan_bsa_lump_or_swelling_in_armpit": "ଆପଣଙ୍କ କାଖରେ କୌଣସି ଗାଠି ଅଛି କି?",
        "label_low_risk": "କମ୍ ବିପଦ",
        "label_moderate_risk": "ମଧ୍ୟମ ବିପଦ",
        "label_high_risk": "ଅଧିକ ବିପଦ",
        "label_very_high_risk": "ଅତ୍ୟଧିକ ବିପଦ"
      }
    };
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
