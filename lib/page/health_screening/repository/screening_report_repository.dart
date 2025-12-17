import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import '../dto/get_measurement_response_dto.dart';
import '../dto/measurement_dto.dart';

class ScreeningReportRepository {
  final HttpProvider provider = Get.find();

  Future<List<MeasurementDTO>?> receiveData(String param, {bool checkForceUpdate = false}) async {
    try {
      var response = await provider.GET(param);
      if (response.isOk) {
        GetMeasurementResponseDTO responseDto = GetMeasurementResponseDTO.fromJson(response.body);
        return MeasurementDTO.fromJsonList(responseDto.content);
      }
      return null;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<MeasurementDTO?> sendData(String param, dynamic data) async {
    try {
      Response response = await provider.POST(param, data);
      if (response.isOk) {
        return MeasurementDTO.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }
}
