
import 'measurement_dto.dart';

class ScreeningReportResultDetailsArgument {
  ScreeningReportResultDetailsArgument({
      this.screeningReport, 
      this.isHistoryView,
      this.measurementsWithResult,
      this.isAuto,});

  ScreeningReportResultDetailsArgument.fromJson(dynamic json) {
    screeningReport = json['screeningReport'];
    isAuto = json['isAuto'];
    isHistoryView = json['isHistoryView'];
    measurementsWithResult = json['measurementsWithResult'] != null? List<MeasurementDTO>.from(json['measurementsWithResult'].map((item) => MeasurementDTO.fromJson(item))): null;
  }
  MeasurementDTO? screeningReport;
  List<MeasurementDTO>? measurementsWithResult;
  bool? isAuto;
  bool? isHistoryView;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['screeningReport'] = screeningReport;
    map['isAuto'] = isAuto;
    map['isHistoryView'] = isHistoryView;
    map['measurementsWithResult'] = measurementsWithResult;
    return map;
  }
}