import 'package:flutter_test/flutter_test.dart';
import 'package:cmed_lib_flutter/cmed_lib_flutter.dart';
import 'package:cmed_lib_flutter/cmed_lib_flutter_platform_interface.dart';
import 'package:cmed_lib_flutter/cmed_lib_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCmedLibFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CmedLibFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CmedLibFlutterPlatform initialPlatform = CmedLibFlutterPlatform.instance;

  test('$MethodChannelCmedLibFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCmedLibFlutter>());
  });

  test('getPlatformVersion', () async {
    CmedLibFlutter cmedLibFlutterPlugin = CmedLibFlutter();
    MockCmedLibFlutterPlatform fakePlatform = MockCmedLibFlutterPlatform();
    CmedLibFlutterPlatform.instance = fakePlatform;

    expect(await cmedLibFlutterPlugin.getPlatformVersion(), '42');
  });
}
