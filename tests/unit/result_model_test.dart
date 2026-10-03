import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_base/domain/models/result.dart';
import 'package:flutter_firebase_base/domain/models/user_model.dart';

void main() {
  group('Result & Domain Model Tests', () {
    test('Success returns data and isSuccess is true', () {
      const result = Success('sample_data');
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals('sample_data'));
      expect(result.errorOrNull, isNull);
    });

    test('Failure returns message and isFailure is true', () {
      const result = Failure<String>('error_message');
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, equals('error_message'));
    });

    test('UserModel serialization and equality', () {
      final user = UserModel(
        uid: 'user_123',
        email: 'dev@example.com',
        displayName: 'Dev User',
      );

      final json = user.toJson();
      expect(json['uid'], equals('user_123'));
      expect(json['email'], equals('dev@example.com'));

      final fromJsonUser = UserModel.fromJson(json);
      expect(fromJsonUser, equals(user));
    });
  });
}
