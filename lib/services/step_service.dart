import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepService {
  StreamSubscription<StepCount>? _subscription;
  final StreamController<int> _stepsController = StreamController<int>.broadcast();
  int _baseline = 0;
  int _lastRaw = 0;
  bool _started = false;

  Stream<int> get stepsStream => _stepsController.stream;

  Future<bool> ensurePermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<void> start({
    required int todayBaseline,
    Future<void> Function(int baseline)? onBaselineEstablished,
  }) async {
    _baseline = todayBaseline;
    if (_started) return;
    _started = true;

    final ok = await ensurePermission();
    if (!ok) {
      debugPrint('Activity recognition permission denied — steps disabled.');
      _stepsController.add(0);
      return;
    }

    try {
      _subscription = Pedometer.stepCountStream.listen(
        (event) {
          _lastRaw = event.steps;
          if (_baseline == 0) {
            _baseline = _lastRaw;
            if (onBaselineEstablished != null) {
              unawaited(onBaselineEstablished(_baseline));
            }
          }
          final today = (_lastRaw - _baseline).clamp(0, 200000);
          _stepsController.add(today);
        },
        onError: (Object error) {
          debugPrint('Step counter error: $error');
          _stepsController.add(0);
        },
        cancelOnError: false,
      );
    } catch (error) {
      debugPrint('Step counter unavailable: $error');
      _stepsController.add(0);
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _stepsController.close();
  }
}
