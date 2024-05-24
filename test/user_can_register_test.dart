import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medix/models/user.dart';
import 'package:medix/services/perform_request.dart';

void main() {
  group("User register", () {
    //test passée
    test("Successful register returns authentication token", () async {
      const endpoint = '/user/register';
      Map<String, dynamic> user = {
        'name': "testLastName",
        'first_name': "testFirsName",
        'phone': "31114824",
        'avatar': null,
        'city_id': 1,
        'birthday': "2000-03-14",
        'password': "userPassword",
        'sex': "M",
        'one_signal_id': null,
        'device_id': "registerTestDeviceId"
      };
      await dotenv.load(fileName: ".env");

      final String? token = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: null, local: "fr"),
          body: json.encode(user),
          onSuccess: (dynamic data, int statusCode) => data['token'],
          onError: (String error, int statusCode) => null);

      expect(token, isNotNull);
      expect(token, isNotEmpty);
    });

    //test passée
    test("Can get user info with authentication token", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user';
      const token = "54|7meFCu1twtkVIwSW7ad3s5l4d09gtgkeE0m6PnXp358c7ca0";
      final User? user = await performRequest(
        endpoint: endpoint,
        headers: buildHeader(token: token, local: "fr"),
        method: 'POST',
        onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
        onError: (error, statusCode) => null,
      );

      // Utilisez isA<User>() pour vérifier le type
      expect(user, isA<User>());
    });
  });
}
