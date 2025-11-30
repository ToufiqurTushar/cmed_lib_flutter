import 'dart:convert';
import 'package:cmed_lib_flutter/common/helper/toast_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'dto/field_dto.dart';
import 'dto/survey_dto.dart';
import 'dto/tab_page.dart';
import 'enum/enum.dart';

class SurveyManagerLogic extends RapidStartLogic  with SingleGetTickerProviderMixin {
  final String? jsonAssetDirectory;
  final bool isTabStyle;
  final List<SurveyDto> surveys;
  final List<TabPage>? tabContents;
  final SurveyDto? selectedSurvey;
  final Function(SurveyDto, Map<String, dynamic>)? onSubmit;
  SurveyManagerLogic({this.jsonAssetDirectory, this.selectedSurvey, this.isTabStyle = false, required this.surveys, this.onSubmit, this.tabContents});

  final allSurveys = <SurveyDto>[].obs;
  final selectedSurveys = <SurveyDto>[].obs;
  var isFormValid = false.obs;
  var formKey = GlobalKey<FormBuilderState>();

  var currentTab = 0.obs;

  /// store all answers
  var answers = <String, dynamic>{}.obs;

  late TabController tabController;
  List<TabPage> tabPages = [];
  var tabTextList = <Tab>[].obs;
  var tabContentList = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: tabContents?.length??0, animationDuration:Duration.zero, );

    loadSurvey();
  }

  /// TAB VISIBILITY RULE
  bool isTabVisible(TabPage tab) {
    if (tab.visibleWhen == null) return true;

    final rule = tab.visibleWhen!.split(":");
    String field = rule[0];
    String neededValue = rule[1];

    return answers[field] == neededValue;
  }


  /// FIELD VISIBILITY
  bool questionVisible(Field field) {
    bool isVisiable = field.visibleWhen(formKey, answers);
    return isVisiable;
  }


  /// VALIDATION — all fields must be filled
  bool validateCurrentTab(TabPage tab) {
    for (Field q in tab.questions??[]) {
      if (questionVisible(q)) {
        if (!answers.containsKey(q.name) ||
            answers[q.name] == null ||
            answers[q.name].toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  /// NEXT TAB
  void nextTab(List<TabPage> visibleTabs) {
    final current = visibleTabs[currentTab.value];

    if (!validateCurrentTab(current)) {
      ShowToast.error("Please fill all required fields");
      return;
    }

    int next = currentTab.value + 1;
    if (next < visibleTabs.length) {
      currentTab.value = next;
      tabController.index = currentTab.value;
    }
  }

  /// PREVIOUS TAB
  void prevTab(List<TabPage> visibleTabs) {
    int prev = currentTab.value - 1;
    if (prev >= 0) {
      currentTab.value = prev;
      tabController.index = currentTab.value;
    }
  }

  /// SAMPLE FORM DATA
  List<TabPage> _loadTabs(SurveyDto survey, List<TabPage>? tabContents) {
    if(tabContents?.isNotEmpty??false) {
      tabContents = tabContents!.map((tabPage){
        var filterredQuestions = survey.fields!.where((field)=>tabPage.listOfQuestionUid?.contains(field.name)??false).toList();
        tabPage.questions = filterredQuestions;
        return tabPage;
      }).toList();

      tabController = TabController(vsync: this, length: tabContents.length, animationDuration:Duration.zero);
      tabTextList.value = tabContents.map((e)=>Tab(
        text: e.title,
      )).toList();
    }
    return tabContents??[];
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

    if(isTabStyle) {
      tabPages = _loadTabs(selectedSurvey!, tabContents);
    }
  }


  void formSubmit(selectedSurvey) {
    final isValid = formKey.currentState!.saveAndValidate();
    if(isValid) {
      final formMap = formKey.currentState!.value;
      
      if(answers.isNotEmpty){
        RLog.warning(answers);
        onSubmit?.call(selectedSurvey, answers);
      } else {
        RLog.warning(formMap);
        onSubmit?.call(selectedSurvey, formMap);
      }
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
