import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'dto/field_dto.dart';
import 'dto/survey_dto.dart';

class SurveyManagerLogic extends RapidStartLogic {
  final String? jsonAssetDirectory;
  final List<SurveyDto> surveys;
  final SurveyDto? selectedSurvey;
  final Function(SurveyDto, Map<String, dynamic>)? onSubmit;
  SurveyManagerLogic({this.jsonAssetDirectory, this.selectedSurvey, required this.surveys, this.onSubmit});

  final allSurveys = <SurveyDto>[].obs;
  final selectedSurveys = <SurveyDto>[].obs;
  var isFormValid = false.obs;
  var formKey = GlobalKey<FormBuilderState>();

  @override
  void onInit() {
    super.onInit();
    loadSurvey();
  }

  Future<void> loadSurvey() async {
    if(jsonAssetDirectory != null) {
      final String jsonStr = await rootBundle.loadString(jsonAssetDirectory!);
      final dynamic jsonData = json.decode(jsonStr);
      allSurveys.value = SurveyDataResponseDto.fromJson(jsonData).content??[];
    } else {
      allSurveys.value = surveys;
    }

    selectedSurveys.clear();
    //if selectedSurvey is not null, load that survey
    if(selectedSurvey != null) {
      selectedSurveys.value = [selectedSurvey!];
    }
  }

  void updateAnswer(Field field, Option option) {
    
  }

  void formSubmit(selectedSurvey) {
    final isValid = formKey.currentState!.saveAndValidate();
    if(isValid) {
      final formMap = formKey.currentState!.value;
      RLog.info(formMap);
      onSubmit?.call(selectedSurvey, formMap);
    }
    else {
      for (var entry in formKey.currentState!.fields.entries) {
        final fieldName = entry.key;
        final fieldState = entry.value;
        if (fieldState.hasError) {
          final context = formKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              alignment: 0.1,
            );
          }
          break;
        }
      }
    }

  }

  bool checkRequiredFieldValidation() {
    formKey.currentState!.save();
    final formState = formKey.currentState!;

    bool isValid = true;
    // //required validation
    for (final field in selectedSurveys.first.fields!) {
      if (field.required??false) {
        final fieldState = formState.fields[field.name];
        final value = fieldState?.value;
        if (value == null || value.toString().trim().isEmpty) {
          isValid = false;
          break;
        }
      }
    }

    return isValid;
  }

}
