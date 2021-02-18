import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warmup_routine/warmup_routine.dart';

void main() {
  const MethodChannel channel = MethodChannel('warmup_routine');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await WarmupRoutine.platformVersion, '42');
  });
}
