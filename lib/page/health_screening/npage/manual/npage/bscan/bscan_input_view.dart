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
          backgroundColor: controller.isNestedRoute?Colors.transparent:null,
          appBar: controller.isNestedRoute? null: BasicAppBar('label_breast_cancer_screening'.tr),
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
