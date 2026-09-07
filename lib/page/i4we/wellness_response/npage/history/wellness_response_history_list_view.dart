import 'package:cmed_lib_flutter/common/helper/date_utils.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/survey/widget/item_survey_result.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../common/widget/basic_app_bar.dart';

import 'wellness_response_history_list_logic.dart';
import '../../wellness_response_view.dart';
import '../../wellness_response_argument.dart';
import 'package:age_calculator/age_calculator.dart';


class WellnessResponseHistoryListView extends RapidView<WellnessResponseHistoryListLogic> {
  static const routeName = '/WellnessResponseHistoryListView';
  final bool showAppTitle;
  WellnessResponseHistoryListView({super.key, this.showAppTitle = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppBar("Wellness Response".tr, showTitleBar:showAppTitle),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                    ()=> builListContainer(context),
              ),
            ),
          ]
      ),

    );
  }

  builListContainer(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount:controller.surveyResultList.length,
              itemBuilder: (context, index) {
                var surveyDto = controller.surveyResultList[index];
                var title = surveyDto.surveyName!;
                var date = CustomDateUtils.format(surveyDto.surveyOn??DateTime.now().millisecondsSinceEpoch, format: 'EEE, dd MMM yyyy, hh:mma',).trDigit();
                var daysAgo = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(surveyDto.surveyOn!)).inDays;
                var subtitle = "${daysAgo} days ago";
                if(daysAgo == 0){
                  subtitle = "Today".tr;
                } else if(daysAgo == 1){
                  subtitle = "Yesterday".tr;
                } else {
                  subtitle = controller.formatSingleUnitAgo(DateTime.fromMillisecondsSinceEpoch(surveyDto.surveyOn!));
                }
                return SurveyResultItemWidget(
                    context: context,
                    title: title,
                    subtitle: subtitle.toString(),
                    color: Theme.of(context).primaryColor,
                    serverImage: "",
                    defaultImage: 'assets/images/ic_wellness_response.svg',
                    date: date ,
                    onTap:(){
                      Get.toNamed(WellnessResponseView.routeName, arguments: WellnessResponseArgument(isFromHistory: true, surveyResultItemDto: surveyDto));
                    }
                );
              }
          ),
        ),
        Visibility(
          visible: !controller.globalState.isSystemBusy.value && controller.surveyResultList.isEmpty,
          child: Align(
            alignment: Alignment.center,
            child: Text('Empty'.tr),
          ),
        )
      ],
    );
  }

  @override
  Map<String, Map<String, String>> getI18n() {
    return {
      'en': {
        'year_month_day_ago': '@years years @months months and @days days ago',
        'month_day_ago': '@months months and @days days ago',
        'day_ago': '@days days ago',
        'single_year_ago': '@years year ago',
        'single_years_ago': '@years years ago',
        'single_month_ago': '@months month ago',
        'single_months_ago': '@months months ago',
        'single_day_ago': '@days day ago',
        'single_days_ago': '@days days ago',
        'Wellness Response': 'Wellness Response',
      },

      'bn': {
        'year_month_day_ago': '@years বছর @months মাস এবং @days দিন আগে',
        'month_day_ago': '@months মাস এবং @days দিন আগে',
        'day_ago': '@days দিন আগে',
        'single_year_ago': '@years বছর আগে',
        'single_years_ago': '@years বছর আগে',
        'single_month_ago': '@months মাস আগে',
        'single_months_ago': '@months মাস আগে',
        'single_day_ago': '@days দিন আগে',
        'single_days_ago': '@days দিন আগে',
        'Wellness Response': 'ওয়েলনেস প্রতিক্রিয়া',
      },

      'kn': {
        'year_month_day_ago': '@years ವರ್ಷ @months ತಿಂಗಳು ಮತ್ತು @days ದಿನಗಳ ಹಿಂದೆ',
        'month_day_ago': '@months ತಿಂಗಳು ಮತ್ತು @days ದಿನಗಳ ಹಿಂದೆ',
        'day_ago': '@days ದಿನಗಳ ಹಿಂದೆ',
        'single_year_ago': '@years ವರ್ಷ ಹಿಂದೆ',
        'single_years_ago': '@years ವರ್ಷಗಳ ಹಿಂದೆ',
        'single_month_ago': '@months ತಿಂಗಳು ಹಿಂದೆ',
        'single_months_ago': '@months ತಿಂಗಳುಗಳ ಹಿಂದೆ',
        'single_day_ago': '@days ದಿನ ಹಿಂದೆ',
        'single_days_ago': '@days ದಿನಗಳ ಹಿಂದೆ',
        'Wellness Response': 'ವೆಲ್ಲ್ನೆಸ್ ಪ್ರತಿಕ್ರಿಯೆ',
      },

      'hi': {
        'year_month_day_ago': '@years वर्ष @months महीने और @days दिन पहले',
        'month_day_ago': '@months महीने और @days दिन पहले',
        'day_ago': '@days दिन पहले',
        'single_year_ago': '@years वर्ष पहले',
        'single_years_ago': '@years वर्ष पहले',
        'single_month_ago': '@months महीना पहले',
        'single_months_ago': '@months महीने पहले',
        'single_day_ago': '@days दिन पहले',
        'single_days_ago': '@days दिन पहले',
        'Wellness Response': 'वेलनेस प्रतिक्रिया',
      },

      'te': {
        'year_month_day_ago': '@years సంవత్సరాలు @months నెలలు మరియు @days రోజులు క్రితం',
        'month_day_ago': '@months నెలలు మరియు @days రోజులు క్రితం',
        'day_ago': '@days రోజుల క్రితం',
        'single_year_ago': '@years సంవత్సరం క్రితం',
        'single_years_ago': '@years సంవత్సరాలు క్రితం',
        'single_month_ago': '@months నెల క్రితం',
        'single_months_ago': '@months నెలలు క్రితం',
        'single_day_ago': '@days రోజు క్రితం',
        'single_days_ago': '@days రోజులు క్రితం',
        'Wellness Response': 'వెల్నెస్ రిస్పాన్స్',
      },

      'ta': {
        'year_month_day_ago': '@years ஆண்டுகள் @months மாதங்கள் மற்றும் @days நாட்களுக்கு முன்பு',
        'month_day_ago': '@months மாதங்கள் மற்றும் @days நாட்களுக்கு முன்பு',
        'day_ago': '@days நாட்களுக்கு முன்பு',
        'single_year_ago': '@years ஆண்டு முன்பு',
        'single_years_ago': '@years ஆண்டுகள் முன்பு',
        'single_month_ago': '@months மாதம் முன்பு',
        'single_months_ago': '@months மாதங்கள் முன்பு',
        'single_day_ago': '@days நாள் முன்பு',
        'single_days_ago': '@days நாட்கள் முன்பு',
        'Wellness Response': 'நலன் பதில்',
      },

      'or': {
        'year_month_day_ago': '@years ବର୍ଷ @months ମାସ ଏବଂ @days ଦିନ ପୂର୍ବରୁ',
        'month_day_ago': '@months ମାସ ଏବଂ @days ଦିନ ପୂର୍ବରୁ',
        'day_ago': '@days ଦିନ ପୂର୍ବରୁ',
        'single_year_ago': '@years ବର୍ଷ ପୂର୍ବରୁ',
        'single_years_ago': '@years ବର୍ଷ ପୂର୍ବରୁ',
        'single_month_ago': '@months ମାସ ପୂର୍ବରୁ',
        'single_months_ago': '@months ମାସ ପୂର୍ବରୁ',
        'single_day_ago': '@days ଦିନ ପୂର୍ବରୁ',
        'single_days_ago': '@days ଦିନ ପୂର୍ବରୁ',
        'Wellness Response': 'ସୁସ୍ଥତା ପ୍ରତିକ୍ରିୟା',
      },
    };
  }

  @override
  String getRouteName() {
    return routeName;
  }

  @override
  void loadDependentLogics() {
    Get.lazyPut<WellnessResponseHistoryListLogic>(() => WellnessResponseHistoryListLogic(),);
  }
}