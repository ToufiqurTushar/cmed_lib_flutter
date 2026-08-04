
import 'measurement_dto.dart';

class ScreeningReportResultDetailsArgument {
  ScreeningReportResultDetailsArgument({
      this.screeningReport, 
      this.screeningReportHfa,
      this.screeningReportHfaCmValue,
      this.screeningReportWfa,
      this.screeningReportWfaKgValue,
      this.screeningReportWfl,
      this.screeningReportWflKgValue,
      this.isHistoryView,
      this.measurementsWithResult,
      this.isNestedRoute,
      this.isThemeV2,
      this.hideDownload,
      this.hideTitle,
      this.hideAdvice,
      this.isAuto,});

  ScreeningReportResultDetailsArgument.fromJson(dynamic json) {
    screeningReport = json['screeningReport'];
    screeningReportHfa = json['screeningReportHfa'];
    screeningReportHfaCmValue = json['screeningReportHfaCmValue'];
    screeningReportWfa = json['screeningReportWfa'];
    screeningReportWfaKgValue = json['screeningReportWfaKgValue'];
    screeningReportWfl = json['screeningReportWfl'];
    screeningReportWflKgValue = json['screeningReportWflKgValue'];
    isAuto = json['isAuto'];
    isHistoryView = json['isHistoryView'];
    isNestedRoute = json['isNestedRoute'];
    isThemeV2 = json['isThemeV2'];
    hideAdvice = json['hideAdvice'];
    hideDownload = json['hideDownload'];
    hideTitle = json['hideTitle'];
    measurementsWithResult = json['measurementsWithResult'] != null? List<MeasurementDTO>.from(json['measurementsWithResult'].map((item) => MeasurementDTO.fromJson(item))): null;
  }
  MeasurementDTO? screeningReport;
  MeasurementDTO? screeningReportHfa;
  num? screeningReportHfaCmValue;
  MeasurementDTO? screeningReportWfa;
  num? screeningReportWfaKgValue;
  MeasurementDTO? screeningReportWfl;
  num? screeningReportWflKgValue;
  List<MeasurementDTO>? measurementsWithResult;
  bool? isAuto;
  bool? isHistoryView;
  bool? isNestedRoute;
  bool? isThemeV2;
  bool? hideTitle;
  bool? hideDownload;
  bool? hideAdvice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['screeningReport'] = screeningReport;
    map['screeningReportHfa'] = screeningReportHfa;
    map['screeningReportHfaCmValue'] = screeningReportHfaCmValue;
    map['screeningReportWfa'] = screeningReportWfa;
    map['screeningReportWfaKgValue'] = screeningReportWfaKgValue;
    map['screeningReportWfl'] = screeningReportWfl;
    map['screeningReportWflKgValue'] = screeningReportWflKgValue;
    map['isAuto'] = isAuto;
    map['isHistoryView'] = isHistoryView;
    map['measurementsWithResult'] = measurementsWithResult;
    map['isNestedRoute'] = isNestedRoute;
    map['isThemeV2'] = isThemeV2;
    map['hideTitle'] = hideTitle;
    map['hideAdvice'] = hideAdvice;
    map['hideDownload'] = hideDownload;
    return map;
  }
}