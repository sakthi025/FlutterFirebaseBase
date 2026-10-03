import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_base/core/api_gateway/api_exceptions.dart';
import 'package:flutter_firebase_base/core/api_gateway/api_response.dart';

void main() {
  group('API Gateway Model & Exception Tests', () {
    test('ApiResponse.success stores payload and 200 code', () {
      final response = ApiResponse.success({'key': 'value'});
      expect(response.success, isTrue);
      expect(response.statusCode, equals(200));
      expect(response.data?['key'], equals('value'));
    });

    test('ApiResponse.failure stores error message and status code', () {
      final response = ApiResponse<dynamic>.failure('Not Found', statusCode: 404);
      expect(response.success, isFalse);
      expect(response.statusCode, equals(404));
      expect(response.message, equals('Not Found'));
    });

    test('ApiException hierarchy checks', () {
      final unauth = UnauthorizedException();
      expect(unauth.statusCode, equals(401));

      final server = ServerException();
      expect(server.statusCode, equals(500));
    });
  });
}
