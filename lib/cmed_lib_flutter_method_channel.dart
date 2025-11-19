import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cmed_lib_flutter_platform_interface.dart';

/// An implementation of [CmedLibFlutterPlatform] that uses method channels.
class MethodChannelCmedLibFlutter extends CmedLibFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cmed_lib_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
