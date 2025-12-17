import 'package:cmed_blood_glucose_devices_lib/cmed_blood_glucose_devices_lib.dart';
import 'package:get/get.dart';

class DnurseDeviceHandler extends GetxController {
  late CmedBloodGlucoseDevicesLib cmedBloodGlucoseDevicesLib;
  final RxString status = "".obs;
  final RxString reading = "".obs;
  bool isConnected = false;

  @override
  void onInit() {
    super.onInit();
    cmedBloodGlucoseDevicesLib = CmedBloodGlucoseDevicesLib();
  }

  connect() async {
    if(!isConnected){
      isConnected = true;
    }
    cmedBloodGlucoseDevicesLib.getStatus().listen((event) {
      status.value = event.toString();
      if(event.toString().contains("CN_SPO2_DATA")) {
        reading.value = event.toString().split(":")[1];
      }
    });
    await cmedBloodGlucoseDevicesLib.connect();
  }

  disconnect() async {
    isConnected = false;
    await cmedBloodGlucoseDevicesLib.disconnect();
  }
}