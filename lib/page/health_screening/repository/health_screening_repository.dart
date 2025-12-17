import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:cmed_lib_flutter/common/api/app_http.dart';
import '../dto/request_bundle_measurement_dto.dart';


class HealthScreeningRepository {
  final HttpProvider provider = Get.find();

  Future receiveData(String path, {bool checkForceUpdate = false}) async {

  }

  Future<RequestBundleMeasurementDto?> sendData(String path, data) async {
    var response = await provider.POST(path, data);
    if (response.isOk) return RequestBundleMeasurementDto.fromJson(response.body);
    return null;
  }
}