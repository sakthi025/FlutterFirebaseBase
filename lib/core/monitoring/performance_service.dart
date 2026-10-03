import 'package:firebase_performance/firebase_performance.dart';
import '../logging/app_logger.dart';

/// Monitoring service for application performance traces via [FirebasePerformance].
class PerformanceService {
  PerformanceService({FirebasePerformance? performance})
      : _performance = performance ?? FirebasePerformance.instance;

  final FirebasePerformance _performance;

  /// Start a custom trace and return the trace instance
  Future<Trace> startTrace(String traceName) async {
    AppLogger.instance.debug('Starting performance trace: $traceName');
    final trace = _performance.newTrace(traceName);
    await trace.start();
    return trace;
  }

  /// Convenient helper to measure the execution time of an async callback
  Future<T> measure<T>(String traceName, Future<T> Function() action) async {
    final trace = await startTrace(traceName);
    try {
      return await action();
    } finally {
      await trace.stop();
      AppLogger.instance.debug('Stopped performance trace: $traceName');
    }
  }

  /// Create an HTTP metric tracker for manual request monitoring
  HttpMetric createHttpMetric(String url, HttpMethod method) {
    return _performance.newHttpMetric(url, method);
  }

  /// Toggle performance data collection
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    await _performance.setPerformanceCollectionEnabled(enabled);
  }
}
