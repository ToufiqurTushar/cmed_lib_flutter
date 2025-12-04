import 'package:cmed_lib_flutter/survey/survey_manager_logic.dart';
import 'package:cmed_lib_flutter/survey/widget/app_dialog.dart';
import 'package:cmed_lib_flutter/survey/widget/decimal_edittext.dart';
import 'package:cmed_lib_flutter/survey/widget/edittext.dart';
import 'package:cmed_lib_flutter/survey/widget/item_group.dart';
import 'package:cmed_lib_flutter/survey/widget/number_edittext.dart';
import 'package:cmed_lib_flutter/survey/widget/radio_groups.dart';
import 'package:cmed_lib_flutter/survey/widget/select_date.dart';
import 'package:cmed_lib_flutter/survey/widget/select_date_time.dart';
import 'package:cmed_lib_flutter/survey/widget/switch_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'dto/field_dto.dart';
import 'dto/survey_dto.dart';
import 'dto/tab_page.dart';


class SurveyManagerWidget extends RapidBasicView<SurveyManagerLogic> {
  final String? jsonAssetDirectory;
  final bool isTabStyle;
  final List<TabPage>? tabContents;
  final List<SurveyDto> surveys;
  final SurveyDto? selectedSurvey;
  final Function(SurveyDto, Map<String, dynamic>)? onSubmit;
  final Function(dynamic)? onSelectAnswer;
  final Function(SurveyDto?)? onSelectSurvey;
  final bool showSerialNumber;
  const SurveyManagerWidget({super.key, this.jsonAssetDirectory,this.isTabStyle = false, this.selectedSurvey, required this.surveys, this.onSelectAnswer, this.onSelectSurvey, this.onSubmit, this.showSerialNumber = true, this.tabContents});

  @override
  SurveyManagerLogic get controller => Get.put(SurveyManagerLogic(jsonAssetDirectory:jsonAssetDirectory, isTabStyle: isTabStyle, surveys:surveys, onSubmit: onSubmit, selectedSurvey: selectedSurvey, tabContents: tabContents));

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allSurveys.isEmpty) return const Center(child: CircularProgressIndicator());

      //category list
      if (controller.selectedSurveys.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          iconPath: survey.icon??'',
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
      final visibleTabs = controller.tabPages.where(controller.isTabVisible).toList();

      return WillPopScope(
        onWillPop: () async {
          if(controller.selectedSurveys.isNotEmpty) {
            AppDialogs.showDoubleButtonDialog(
              'Do you want to go back ?'.tr,
              onPositiveButtonClick: () => {
                if(controller.allSurveys.length ==1){
                  Get.back(),
                } else {
                  controller.selectedSurveys.clear(),
                  controller.isFormValid.value = false,
                  onSelectSurvey?.call(null),
                }
              }
            );

            return false;
          }
          return true;
        },
        child: controller.isTabStyle?
        Obx(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  child: Card(
                    elevation: 2,
                    child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3.0,
                      isScrollable: true,
                      controller: controller.tabController,
                      indicatorPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      //labelStyle: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs:  controller.tabTextList,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.tabController,
                    children: _buildTabContents(visibleTabs, context, controller.formKey),
                  ),
                ),
                _buildNavigation(visibleTabs),
                //_buildTabHeader(visibleTabs),
                //Expanded(child: _buildTabContent(visibleTabs, context, controller.formKey)),
                //
              ],
            ),
          ),
        ):
        SingleChildScrollView(
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
                      //Text(selectedSurvey.name!, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      //const SizedBox(height: 8),
                      ...selectedSurvey.fields!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final field = entry.value;
                        if(showSerialNumber) {
                          field.serial = '${(index+1)}';
                        }
                        return _buildReactiveField(field, context, controller.formKey);
                      }).toList(),
                      const SizedBox(height: 16),
                      //result button
                      const SizedBox(height: 8,),
                      Obx(
                        ()=> Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: FrElevatedButton(
                              name:'SEE RESULT'.tr, onPressed: () async => {
                                controller.formSubmit(selectedSurvey)
                              },
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isFormValid.value? Theme.of(context).primaryColor: Colors.grey,
                                foregroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Rounded corners
                                ),
                                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
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


  Widget _buildField(Field field, context, formKey, {Function(String fieldName, dynamic val)? onChanged}) {
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
                  onChanged?.call(field.name!, val);
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.number) {
      return Column(
        children: [
          NumberEditText(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                num value = 0;
                final parsedInt = int.tryParse(val);
                final parsedDouble = double.tryParse(val);
                if(parsedInt != null  && parsedDouble != null){
                  if(parsedDouble > parsedInt) {
                    value = parsedDouble;
                  } else {
                    value = parsedInt;
                  }
                  onSelectAnswer?.call(value);
                  onChanged?.call(field.name!, value);
                }
                //controller.formKey.currentState!.fields[field.name]!.invalidate("Less Than 24");
                //controller.formKey.currentState!.fields[field.name]!.validate();
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.radio) {
      return Column(
        children: [
          RadioGroups(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                onSelectAnswer?.call(val);
                onChanged?.call(field.name!, val);
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.text) {
      return Column(
        children: [
          EditText(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                onSelectAnswer?.call(val);
                onChanged?.call(field.name!, val);
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.date || field.dateStart || field.dateEnd) {
      return Column(
        children: [
          SelectDate(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (value) {
                final pickedDate = DateTime.fromMicrosecondsSinceEpoch(value);
                var formattedDate = DateTime.now().millisecondsSinceEpoch;
                if(field.dateStart) {
                  final combinedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    0,
                    0,
                    0,
                  );
                  formattedDate = combinedDateTime.millisecondsSinceEpoch;
                }
                else if(field.date) {
                  final combinedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    DateTime.now().hour,
                    DateTime.now().minute,
                    DateTime.now().second,
                  );
                  formattedDate = combinedDateTime.millisecondsSinceEpoch;
                }
                else if(field.dateEnd) {
                  final combinedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    23,
                    59,
                    59,
                  );
                  formattedDate = combinedDateTime.millisecondsSinceEpoch;
                }
                RLog.error(field.inputType);
                onSelectAnswer?.call(formattedDate);
                onChanged?.call(field.name!, formattedDate);
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.dateTime) {
      return Column(
        children: [
          SelectDateTime(
            field: field,
            context: context,
            formKey: formKey,
            padding: 12,
            elevation: 2,
            onChanged: (val){
              onSelectAnswer?.call(val);
              onChanged?.call(field.name!, val);
            }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    else if(field.decimal) {
      return Column(
        children: [
          DecimalEditText(
              field: field,
              context: context,
              formKey: formKey,
              padding: 12,
              elevation: 2,
              onChanged: (val){
                num value = 0;
                final parsedInt = int.tryParse(val);
                final parsedDouble = double.tryParse(val);
                if(parsedInt != null  && parsedDouble != null){
                  if(parsedDouble > parsedInt) {
                    value = parsedDouble;
                  } else {
                    value = parsedInt;
                  }
                  onSelectAnswer?.call(value);
                  onChanged?.call(field.name!, value);
                }
                //controller.formKey.currentState!.fields[field.name]!.invalidate("Less Than 24");
                //controller.formKey.currentState!.fields[field.name]!.validate();
              }
          ),
          const SizedBox(height: 8,)
        ],
      );
    }
    return Text("Unknown Input Type: ${field.inputType}");
  }

  Widget _buildTabHeader(List<TabPage> visibleTabs) {
    return Obx(() {
      return Row(
        children: List.generate(visibleTabs.length, (i) {
          final isSelected = i == controller.currentTab.value;

          return Expanded(
            child: Container(
              padding: EdgeInsets.all(14),
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              child: Center(
                child: Text(
                  visibleTabs[i].title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  /* ----------------------------------------------------------
      TAB CONTENT
  -----------------------------------------------------------*/
  List<Widget> _buildTabContents(List<TabPage> visibleTabs, context, formKey) {


      return visibleTabs.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        //final tabIndex = controller.currentTab.value;
        final currentTab = visibleTabs[index];
        Widget tabContent = ListView(
          children: (currentTab.questions??[]).map((field) {
            bool visible = field.visibleWhen(controller.formKey, controller.answers);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(anim),
                  child: FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                );
              },
              child: visible ? _buildReactiveField(field, context, formKey) : const SizedBox.shrink(),
            );
          }).toList(),
        );
        return tabContent;
      }).toList();

  }

  Widget _buildTabContent(List<TabPage> visibleTabs, context, formKey) {
    return Obx(() {
      final tabIndex = controller.currentTab.value;
      final currentTab = visibleTabs[tabIndex];
      return ListView(
        children: (currentTab.questions??[]).map((field) {
          bool visible = field.visibleWhen(controller.formKey, controller.answers);

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(anim),
                child: FadeTransition(
                  opacity: anim,
                  child: child,
                ),
              );
            },
            child: visible ? _buildReactiveField(field, context, formKey) : const SizedBox.shrink(),
          );
        }).toList(),
      );
    });
  }

  // Widget _buildTabContent(List<TabPage> visibleTabs, context, formKey) {
  //   return Obx(() {
  //     final tabIndex = controller.currentTab.value;
  //     final currentTab = visibleTabs[tabIndex];
  //
  //     return AnimatedSwitcher(
  //       duration: Duration(milliseconds: 250),
  //       child: ListView(
  //         key: ValueKey(currentTab.id),
  //         padding: EdgeInsets.all(16),
  //         children: (currentTab.questions??[])
  //             .map((field) => _buildReactiveField(field, context, formKey))
  //             .toList(),
  //       ),
  //     );
  //   });
  // }

  /* ----------------------------------------------------------
      QUESTION FIELD (Obx)
  -----------------------------------------------------------*/

  Widget _buildReactiveField(Field field, context, formKey){
    return Obx(() {
      final value = controller.answers[field.name];
      field.defaultValue = value;
      //formKey.currentState?.patchValue(controller.answers);
      //RLog.warning(value);
      // formKey.currentState?.fields[field.name]?.didChange(value);
      return _buildField(field, context, formKey, onChanged: (name, val) {
        controller.answers[field.name!] = val;
        controller.answers.refresh();
      });
    });
  }

  /* ----------------------------------------------------------
      NAVIGATION
  -----------------------------------------------------------*/

  Widget _buildNavigation(List<TabPage> visibleTabs) {
    return Obx(() {
      final index = controller.currentTab.value;
      final isLast = index == visibleTabs.length - 1;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            if (index > 0)
              Expanded(
                child: Container(
                  height: 50,
                  child: FrElevatedButton(
                    onPressed: () => controller.prevTab(visibleTabs),
                    name: "Back".tr,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(Get.context!).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

           SizedBox(width: 12,),

            Expanded(
              child: Container(
                height: 50,
                child: FrElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      controller.formSubmit(controller.selectedSurveys.first);
                    } else {
                      controller.nextTab(visibleTabs);
                    }
                  },
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(Get.context!).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  name: isLast ? "Finish".tr : "Next".tr,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
