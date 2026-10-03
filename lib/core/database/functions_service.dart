import 'package:cloud_functions/cloud_functions.dart';
import '../logging/app_logger.dart';

/// Service for calling Firebase Cloud Functions (HTTPS callable functions).
class FunctionsService {
  FunctionsService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  FirebaseFunctions get rawInstance => _functions;

  /// Invoke a callable cloud function with optional parameters
  Future<T> call<T>({
    required String functionName,
    dynamic parameters,
  }) async {
    try {
      AppLogger.instance.info('Calling Cloud Function: $functionName');
      final callable = _functions.httpsCallable(functionName);
      final result = await callable.call(parameters);
      return result.data as T;
    } on FirebaseFunctionsException catch (e, stack) {
      AppLogger.instance.error(
        'Cloud Function $functionName failed with code: ${e.code}, message: ${e.message}',
        e,
        stack,
      );
      rethrow;
    } catch (e, stack) {
      AppLogger.instance.error('Unexpected error calling $functionName', e, stack);
      rethrow;
    }
  }

  /// Use local emulator for cloud functions (dev mode)
  void useEmulator({required String host, required int port}) {
    AppLogger.instance.info('Setting Cloud Functions emulator to $host:$port');
    _functions.useFunctionsEmulator(host, port);
  }
}
