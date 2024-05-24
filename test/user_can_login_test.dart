import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medix/services/perform_request.dart';

///Test passée
void main() {
  group('Login Function Tests', () {
    const String endpoint = '/auth/token';
    test('Successful login returns authentication token', () async {
      final credentials = {
        'phone': '41308524',
        'password': 'password',
        'device_id': "deviceIdTestUnit"
      };

      await dotenv.load(fileName: ".env");

      final String? token = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: null, local: 'fr'),
          body: json.encode(credentials),
          onSuccess: (dynamic data, int statusCode) => data['token'],
          onError: (data, code) {
            return null;
          });
      expect(token, isNotNull);
      expect(token, isNotEmpty);
    });

    test('Failed login returns null', () async {
      await dotenv.load(fileName: ".env");
      final invalidCredentials = {
        'phone': '9876543210',
        'password': 'wrongpassword',
        'device_id': "deviceIdTestUnit"
      };

      final String? token = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: null, local: 'fr'),
          body: json.encode(invalidCredentials),
          onSuccess: (dynamic data, int statusCode) => data['token'],
          onError: (data, code) {
            return null;
          });
      expect(token, isNull);
    });
  });
}
