
import 'dart:async';

import 'package:flutter/services.dart';

class WarmupRoutine {
  static const MethodChannel _channel =
      const MethodChannel('warmup_routine');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
