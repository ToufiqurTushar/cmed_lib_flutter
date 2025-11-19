import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cmed_lib_flutter_method_channel.dart';

abstract class CmedLibFlutterPlatform extends PlatformInterface {
  /// Constructs a CmedLibFlutterPlatform.
  CmedLibFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static CmedLibFlutterPlatform _instance = MethodChannelCmedLibFlutter();

  /// The default instance of [CmedLibFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelCmedLibFlutter].
  static CmedLibFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CmedLibFlutterPlatform] when
  /// they register themselves.
  static set instance(CmedLibFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
