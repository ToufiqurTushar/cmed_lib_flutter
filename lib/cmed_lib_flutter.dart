
import 'cmed_lib_flutter_platform_interface.dart';

class CmedLibFlutter {
  Future<String?> getPlatformVersion() {
    return CmedLibFlutterPlatform.instance.getPlatformVersion();
  }
}
