import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/screens/events/notification_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Contrôleur pour la gestion des notifications OneSignal.
///
/// Gère l'initialisation de OneSignal, la demande de permissions, et les écouteurs
/// d'événements pour les notifications et les messages in-app.
class OneSignalNotification extends GetxController {
  /// Indique si le consentement GDPR est nécessaire pour les notifications.
  final bool _requireConsent = false;

  /// Initialisation du contrôleur.
  ///
  /// Configure OneSignal et demande la permission de notification si nécessaire.
  @override
  onInit() {
    super.onInit();
    initPlatformState();
    if (!OneSignal.Notifications.permission) {
      handlePromptForPushPermission();
    }
  }

  /// Gère la demande de permission de notification.
  void handlePromptForPushPermission() {
    OneSignal.Notifications.requestPermission(true);
  }

  /// Initialise l'état de la plateforme OneSignal.
  ///
  /// Configure les niveaux de journalisation, initialise OneSignal avec l'ID de l'application,
  /// et configure les écouteurs pour les événements liés aux notifications et aux messages in-app.
  Future<void> initPlatformState() async {
    if (isClosed) return;

    // Configuration de OneSignal
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(_requireConsent);

    // Initialisation de OneSignal avec l'ID de l'application
    OneSignal.initialize(oneSignalAppId);

    // Ajout des écouteurs pour les événements OneSignal
    OneSignal.Notifications.clearAll();

    //ajouter un observateur pour la mise de l'identifiant oneSignal puour l'utlisateur
    OneSignal.User.pushSubscription.addObserver((state) {
      if (Get.find<Auth>().authenticated.value) {
        Get.find<Auth>().updateUser(
            path: '/auth/user/update/one-signal-id',
            alert: false,
            credential: {'one_signal_id': OneSignal.User.pushSubscription.id});
      }
    });

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      if (kDebugMode) {
        print('OneSignal user changed: $userState');
      }
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      if (kDebugMode) {
        print("Has permission $state");
      }
    });

    OneSignal.Notifications.addClickListener((event) async {
      await Get.to(() => NotificationScreen());
      if (kDebugMode) {
        print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      if (kDebugMode) {
        print(
            'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
      }

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// notification.display() to display after preventing default
      event.notification.display();
    });

    OneSignal.InAppMessages.addClickListener((event) async {
      await Get.to(() => NotificationScreen());

      if (kDebugMode) {
        print(event.result);
      }
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      if (kDebugMode) {
        print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      if (kDebugMode) {
        print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      if (kDebugMode) {
        print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
      }
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      if (kDebugMode) {
        print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
      }
    });

    OneSignal.InAppMessages.paused(true);
  }
}
