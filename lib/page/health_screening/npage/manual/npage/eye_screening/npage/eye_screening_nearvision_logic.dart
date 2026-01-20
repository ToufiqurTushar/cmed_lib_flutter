import 'package:cmed_lib_flutter/common/base/base_logic.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/enum/eye_screening_type_enum.dart';
import 'package:cmed_lib_flutter/common/helper/utils.dart';
import 'package:cmed_lib_flutter/page/health_screening/dto/measurement_dto.dart';
import 'package:cmed_lib_flutter/page/health_screening/npage/manual/npage/eye_screening/npage/eye_screening_result_view.dart';
import 'package:cmed_lib_flutter/common/dto/master_data_dto.dart';
import 'package:flutter_rapid/flutter_rapid.dart';

import '../../../../../repository/screening_report_repository.dart';


class EyeScreeningNearvisionLogic extends BaseLogic {
  late String accessFrom;
  final ScreeningReportRepository repository;
  EyeScreeningNearvisionLogic({required this.repository});

  var letters = [
    "When I was ten years old, my father had a small estate near Satara where he used to take us during the holidays. It was situated in rough and uncultivated country side where wild animals were often seen. Once we heard that there was a panther in the surroundings who was killing the cattle and attacking the villagers. Father had warned me not to wander far from home in the evenings. I had made friends with a young villager called Ramu.",
    "Ramu used to drive the cattle to graze and bring them back to shelter at the end of the day. He was lean and of a short build and was barely fifteen. He used to be my companion whenever I meet him winding his way home. One afternoon, jusi about five o'clock, early in the month of March, chance brought us together.",
    "As there had been considerable variation in the series of Jaeger's test types produced by different printers, a new series of standard graduated test types for near vision has been recommended by the Faculty of Opthalmologists of England in which Times Roman types are used with standard spacing.",
    "The eye to be examined is anaesthetised with 1% solution in anaethine and the instrument is lightly pressed against the eye in the suspected area if there is a solid tumour, the pupil remains dark. Then the instrument is placed on another region when the pupil is found to be red."
  ];
  var lettersBn = [
    "এককালে এক গুহায় একদল ইঁদুর বাস করত। একদিন এক হুলো বিড়াল তাদের সন্ধান পেল। সঙ্গে সঙ্গে তার চোখমুখ চকচক করে ওঠে। জিবে দিয়ে লাল ঝরে। ‘যাক, অনেক দিন পরে আজ কিছু সুস্বাদু আমিষ ভোজন করা যাবে!’ মোচ নাড়ায় আর মনে মনে কথা বলে হুলো বিড়াল। ওদিকে ইঁদুরগুলো প্রাণ হাতে করে থাকতে থাকতে আধমরা। বারবার খালি মিটিংসিটিং করে। নাওয়া-খাওয়া ভুলে প্রাণ রক্ষার উপায় খোঁজে। উপায় আর মেলে না। গুহা ছেড়ে যে পালিয়ে যাবে, তারও উপায় নেই। বিড়ালটা যে গুহার মুখেই শুয়ে থাকে! খিদে লাগলে একটা-দুইটা ইঁদুর ধরে মজা করে খায়।",
    "ব্যাঙেদের খুব দুঃখ, তাদের কোন রাজা নেই। তারা দেবরাজ জুপিটারের কাছে আবেদন জানাল তাদের জন্য রাজা পাঠাতে। জুপিটার দেখলেন, এই ব্যাঙেরা নিতান্তই সহজ সরল। তিনি একটা বিরাট কাঠের গুঁড়ি তাদের মাঝখানে ফেলে দিলেন। কাঠের গুঁড়ির ঝপাং করে জলে পড়ল। সেই পড়ার চোটে ভীষণ ভয় পেয়ে ব্যাঙেরা গভীর জলে লুকিয়ে পড়ল। কিন্তু যেই তারা দেখল যে গুঁড়িটার কোনই নড়ন চড়ন নেই, দল বেঁধে জলের উপর ভেসে উঠল সবাই। গুঁড়িটার প্রতি তাদের আর বিন্দুমাত্র ভয় নেই। এমন অবস্থা হল, তারা ওটার গা বেয়ে ওটার উপর চড়ে বসে রইল। একসময় তাদের মনে হল, এমন একটা নিষ্কর্মা রাজা পাঠিয়ে দেবরাজ তাদের প্রতি বড়ই অবিচার করেছেন।",
    "একদিন তিনবন্ধু তাদের অন্য বন্ধুর বাড়িতে বেড়াতে যাবে। তারা রাস্তা দিয়ে যাচ্ছে সেই রাস্তা জন্গলের ভিতর দিয়ে যায়।তারা হাঁটতে হাঁটতে দেখলো সন্ধ্যায় হয়ে যাচ্ছে।তারা রাত কাঁটানোর জন্য গাছে উটলো। সেই গাছগুলো ছিল অনেক মোটা।তারা তিন জন তিনটি গাছে উটলো।তারা ঘুমিয়ে পরলো।সকালে যখন উটলো তখন তারা একটি বাঘ দেখতে পেল।বিপদ বুঝে এক বন্ধু ভয়ে তার দুই বন্ধুকে রেখেই পালিয়ে গেল! এক বন্ধু দেখতে পেল তার আরেক বন্ধু গাছ থেকে পড়ে গেল।দেখতে পেল মহা বিপদে পড়েছে।সে দেখতে পেল সে যেই গাছে বসে আছে সেই গাছের পাশেই একটি ডাব গাছ।তার মাথায়ছিট একটা বুদ্ধি বার করলো বাঘের খেয়াল নিজের দিকে নিয়ে যখন হা করবে তখনই ডাব তার মুখে ছেড়ে দিবে।সে সহজেই ডাব পারতে পারবে।সে একটি ডাব পারলো। যখন বাঘ তার দিকে চেয়ে হা করল করলো তখনই সঙ্গে সঙ্গে বাঘের মুখে ডাব ছেড়ে দিল এবং বাঘকে পড়াস্ত করল।এই সুযোগে তার বন্ধুকে বাঁচিয়ে সাহসীকতার পরিচয় দিল।"
  ];

  var fontSizes = [3, 4, 5, 6, 8, 10, 12, 16];

  var startScreening = false.obs;
  var screeningIndex = 0.obs;
  var screeningQuestions = <MasterDataDTO>[];
  var countWrongAnswer = 0;

  @override
  void onInit() {
    super.onInit();
    
  final args = Get.arguments;
  if (args != null && args is Map && args.containsKey('accessFrom')) {
    accessFrom = args['accessFrom'];
  } else {
    Exception(args['accessFrom']);
    accessFrom = ''; // or throw/log if required
  }
    screeningQuestions = <MasterDataDTO>[
      MasterDataDTO(name:"N5", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[0]),
      MasterDataDTO(name:"N5", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[0]),
      MasterDataDTO(name:"N5", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[0]),

      MasterDataDTO(name:"N6", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[1]),
      MasterDataDTO(name:"N6", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[1]),
      MasterDataDTO(name:"N6", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[1]),

      MasterDataDTO(name:"N8", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[2]),
      MasterDataDTO(name:"N8", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[2]),
      MasterDataDTO(name:"N8", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[2]),

      MasterDataDTO(name:"N10", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[3]),
      MasterDataDTO(name:"N10", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[3]),
      MasterDataDTO(name:"N10", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[3]),

      MasterDataDTO(name:"N12", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[4]),
      MasterDataDTO(name:"N12", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[4]),
      MasterDataDTO(name:"N12", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[4]),

      MasterDataDTO(name:"N14", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[5]),
      MasterDataDTO(name:"N14", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[5]),
      MasterDataDTO(name:"N14", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[5]),

      MasterDataDTO(name:"N18", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[6]),
      MasterDataDTO(name:"N18", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[6]),
      MasterDataDTO(name:"N18", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[6]),

      MasterDataDTO(name:"N24", labelEn: letters[0], labelBn: lettersBn[0], value: fontSizes[7]),
      MasterDataDTO(name:"N24", labelEn: letters[1], labelBn: lettersBn[1], value: fontSizes[7]),
      MasterDataDTO(name:"N24", labelEn: letters[2], labelBn: lettersBn[2], value: fontSizes[7]),
    ];
  }


  nextScreening({bool clear = false}) {
    if(!clear) {
      countWrongAnswer = 0;
    } else {
      countWrongAnswer++;
    }

    if(countWrongAnswer >= 1) {
      screeningComplete();
    } else {
      var lastIndex = screeningQuestions.length - 1;
      if(screeningIndex.value < lastIndex) {
        screeningIndex.value = screeningIndex.value + 1;
      } else {
        screeningComplete();
      }
    }
  }

  screeningComplete() {
    Get.offNamed(EyeScreeningResultView.routeName, arguments: [
      {
        "accessFrom": accessFrom,
        "screeningReport": MeasurementDTO(
          eyeScreening: [
            EyeScreening(
              eyeScreeningResult : EyeScreeningResult(
                message: getName(),
              ),
              screenType: EyeScreeningTypeEnum.NEAR_VISION_BOTH_EYE.name,
            )
          ],
        )
      }
    ]);
  }

  String getImageAsset() {
    return "assets/images/measurement/${screeningQuestions[screeningIndex.value].image}.png";
  }

  String getName() {
    return screeningQuestions[screeningIndex.value].name??'';
  }
  String getLabel() {
    if(Utils.isLocaleBn()) {
      return screeningQuestions[screeningIndex.value].labelBn??'';
    } else {
      return screeningQuestions[screeningIndex.value].labelEn??'';
    }
  }

  double getFontSize() {
    return screeningQuestions[screeningIndex.value].value?.toDouble()??0;
  }
}