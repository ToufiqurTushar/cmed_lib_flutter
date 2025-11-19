import 'package:cmed_lib_flutter/survey/survey_manager_logic.dart';
import 'package:cmed_lib_flutter/survey/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/survey/widget/item_group.dart';
import 'package:cmed_lib_flutter/survey/widget/number_edittext.dart';
import 'package:cmed_lib_flutter/survey/widget/switch_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'dto/field_dto.dart';
import 'dto/survey_dto.dart';


class SurveyManagerWidget extends RapidBasicView<SurveyManagerLogic> {
  final String? jsonAssetDirectory;
  final List<SurveyDto> surveys;
  final SurveyDto? selectedSurvey;
  final Function(SurveyDto, Map<String, dynamic>)? onSubmit;
  final Function(dynamic)? onSelectAnswer;
  final Function(SurveyDto?)? onSelectSurvey;
  final Color primaryColor;
  const SurveyManagerWidget({super.key, this.jsonAssetDirectory, this.selectedSurvey, required this.surveys, this.onSelectAnswer, this.onSelectSurvey, this.onSubmit, required this.primaryColor});

  @override
  SurveyManagerLogic get controller => Get.put(SurveyManagerLogic(jsonAssetDirectory:jsonAssetDirectory, surveys:surveys, onSubmit: onSubmit, selectedSurvey: selectedSurvey));

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allSurveys.isEmpty) return const Center(child: CircularProgressIndicator());

      if (controller.selectedSurveys.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Health Assessment'.tr, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 0.4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index){
                        return Divider(
                          color: Theme.of(context).primaryColorDark,
                          thickness: 0.5,
                        );
                      },
                      itemCount: controller.allSurveys.length,
                      itemBuilder: (context, index){
                        final survey = controller.allSurveys[index];
                        return GroupItem(
                          iconPath: survey.icon!,
                          label: survey.name!,
                          subLabel: 'Tap to start'.tr,
                          onTap: () {
                            controller.selectedSurveys.value = [
                              survey
                            ];
                            onSelectSurvey?.call(survey);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }

      controller.formKey = GlobalKey<FormBuilderState>();
      return WillPopScope(
        onWillPop: () async {
          if(controller.selectedSurveys.isNotEmpty) {
            AppDialogs.showDoubleButtonDialog(
              'Do you want to go back ?'.tr,
              onPositiveButtonClick: () => {
                controller.selectedSurveys.clear(),
                controller.isFormValid.value = false,
                onSelectSurvey?.call(null),
              }
            );

            return false;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Obx(
            ()=> FormBuilder(
              onChanged: (){
                bool isValid = controller.checkRequiredFieldValidation();
                if (isValid) {
                  controller.isFormValid.value = true;
                } else {
                  controller.isFormValid.value = false;
                }
              },
              key: controller.formKey,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.selectedSurveys.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final selectedSurvey = controller.selectedSurveys[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(selectedSurvey.name!, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 8),
                      ...selectedSurvey.fields!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final field = entry.value;
                        field.serial = '${(index+1)}';
                        return _buildField(field, context, controller.formKey);
                      }).toList(),
                      const SizedBox(height: 16),
                      //result button
                      const SizedBox(height: 8,),
                      Obx(
                        ()=> FrElevatedButton(
                          name:'SEE RESULT'.tr, onPressed: () async => {
                            controller.formSubmit(selectedSurvey)
                          },
                          color:  controller.isFormValid.value? null :Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Rounded corners
                            ),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }


  Widget _buildField(Field field, context, formKey) {
    if(field.switchButton) {
      return Column(
        children: [
          SwitchButtons(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                  onSelectAnswer?.call(val);
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    if(field.number) {
      return Column(
        children: [
          NumberEditText(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                final parsed = int.tryParse(val);
                if (parsed != null && parsed > 24) {
                  //controller.formKey.currentState!.fields[field.name]!.invalidate("Less Than 24");
                } else {
                  //controller.formKey.currentState!.fields[field.name]!.validate();
                  onSelectAnswer?.call(val);
                }
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    return const Text("Unknown Input Type");
  }

}
