import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmed_lib_flutter/cmed_lib_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCmedLibFlutter platform = MethodChannelCmedLibFlutter();
  const MethodChannel channel = MethodChannel('cmed_lib_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
