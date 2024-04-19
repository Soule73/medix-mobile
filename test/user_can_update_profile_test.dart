import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medix/models/user.dart';
import 'package:medix/services/perform_request.dart';

void main() {
  group("User can update", () {
    const token = "54|7meFCu1twtkVIwSW7ad3s5l4d09gtgkeE0m6PnXp358c7ca0";

    test("can update profile informations", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update';
      Map<String, dynamic> user = {
        'name': "testUpdateUserLastName",
        'first_name': "testUpdateUserFirsName",
        'city_id': 1,
        'birthday': "2000-06-14",
        'password': "testUpdateUserPassword",
        'sex': "M",
        'one_signal_id': "3545-6532-5422-5410-5252-5041",
      };

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: "fr"),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) {
            if (kDebugMode) {
              print('$statusCode : $error');
            }
            return null;
          });

      expect(data, isNotNull);
      expect(data, isA<User>());

      if (kDebugMode) {
        print('can update profile informations : ${data?.toJson()}');
      }
      // output :
      // can update profile informations : {id: 21, patien_id: 11, name: testUpdateUserLastName,
      // phone: 31114824, email: null, firstName: testUpdateUserFirsName, sex: M, role: patient,
      // status: active, default_lang: fr,
      //avatar: https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0,
      //fullname: testUpdateUserFirsName testUpdateUserLastName, id_cnss: null,
      //addresse: null, birthday: 2000-06-14T00:00:00.000000Z, city_id: 1,
      //city_name: Nouakchott, one_signal_id: 5547-5725-5892-6824-3523-6548,
      // phone_verified_at: 2024-04-13T03:49:27.000000Z, email_verified_at: null,
      // created_at: 2024-04-13T03:49:27.000000Z, updated_at: 2024-04-13T03:49:27.000000Z}
    });
    test("can update avatar", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/avatar';
      Map<String, dynamic> user = {
        'avatar':
            'https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0'
      };

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: 'fr'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) {
            if (kDebugMode) {
              print('$statusCode : $error');
            }
            return null;
          });

      expect(data, isNotNull);
      expect(data, isA<User>());
      if (kDebugMode) {
        print('can update avatar : ${data?.toJson()}');
      }
      // output :
      // can update avatar : {id: 21, patien_id: 11, name: testUpdateUserLastName, phone: 31114824, email: null,
      //firstName: testUpdateUserFirsName, sex: M, role: patient, status: active, default_lang: fr,
      //avatar: https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0,
      //fullname: testUpdateUserFirsName testUpdateUserLastName, id_cnss: null, addresse: null,
      //birthday: 2000-06-14T00:00:00.000000Z, city_id: 1, city_name: Nouakchott, one_signal_id: 5547-5725-5892-6824-3523-6548,
      // phone_verified_at: 2024-04-13T03:49:27.000000Z, email_verified_at: null, created_at: 2024-04-13T03:49:27.000000Z,
      //updated_at: 2024-04-13T03:49:27.000000Z}
    });
    test("can update default lang", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/default-lang';
      Map<String, dynamic> user = {'default_lang': 'fr'};

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: 'ar'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) {
            if (kDebugMode) {
              print('$statusCode : $error');
            }
            return null;
          });

      expect(data, isNotNull);
      expect(data, isA<User>());
      if (kDebugMode) {
        print('can update default lang : ${data?.toJson()}');
      }

      // output
      // can update default lang : {id: 21, patien_id: 11, name: testUpdateUserLastName, phone: 31114824, email: null,
      //firstName: testUpdateUserFirsName, sex: M, role: patient, status: active, default_lang: fr,
      //avatar: https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0,
      //fullname: testUpdateUserFirsName testUpdateUserLastName, id_cnss: null, addresse: null,
      // birthday: 2000-06-14T00:00:00.000000Z, city_id: 1, city_name: Nouakchott, one_signal_id: 5547-5725-5892-6824-3523-6548,
      //phone_verified_at: 2024-04-13T03:49:27.000000Z, email_verified_at: null, created_at: 2024-04-13T03:49:27.000000Z,
      //updated_at: 2024-04-13T03:49:27.000000Z}
    });
    test("can update oneSignaleId", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/one-signal-id';
      Map<String, dynamic> user = {
        'one_signal_id': '5547-5725-5892-6824-3523-6548'
      };

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: 'fr'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) {
            if (kDebugMode) {
              print('$statusCode : $error');
            }
            return null;
          });

      expect(data, isNotNull);
      expect(data, isA<User>());
      if (kDebugMode) {
        print('can update oneSignaleId : ${data?.toJson()}');
      }
      // output :
      // can update oneSignaleId : {id: 21, patien_id: 11, name: testUpdateUserLastName, phone: 31114824, email: null,
      //firstName: testUpdateUserFirsName, sex: M, role: patient, status: active, default_lang: fr,
      // avatar: https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0,
      //fullname: testUpdateUserFirsName testUpdateUserLastName, id_cnss: null, addresse: null, birthday: 2000-06-14T00:00:00.000000Z,
      // city_id: 1, city_name: Nouakchott, one_signal_id: 5547-5725-5892-6824-3523-6548, phone_verified_at: 2024-04-13T03:49:27.000000Z,
      //email_verified_at: null, created_at: 2024-04-13T03:49:27.000000Z, updated_at: 2024-04-13T03:49:27.000000Z}
    });

    test("can update password", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/password';
      Map<String, dynamic> user = {
        'current_password': "testUpdateUserPassword",
        'password': "testUpdateUserPassword",
      };

      final body = json.encode(user);

      final bool data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: 'fr'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => true,
          onError: (String error, int statusCode) => false);

      expect(data, true);
    });

    test("can't update without valide authentification token", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/one-signal-id';
      Map<String, dynamic> user = {
        'avatar':
            'https://firebasestorage.googleapis.com/v0/b/medix-sds.appspot.com/o/profile_images%2FI9mZeDMW6obAmTejaNvhqB7DtrB2.jpg?alt=media&token=fad2622a-16b6-4064-982c-d55808ce83e0'
      };

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: null, local: 'fr'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) => null);

      expect(data, isNull);
    });
    test("can't update with invalide data", () async {
      await dotenv.load(fileName: ".env");

      const endpoint = '/auth/user/update/one-signal-id';
      Map<String, dynamic> user = {'avatar': null};

      final body = json.encode(user);

      final User? data = await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token, local: 'fr'),
          body: body,
          method: 'PATCH',
          onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
          onError: (String error, int statusCode) => null);

      expect(data, isNull);
    });
  });
}
