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


    OneSignal.Notifications.addClickListener((event) async {
      await Get.to(() => NotificationScreen());
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// notification.display() to display after preventing default
      event.notification.display();
    });

    OneSignal.InAppMessages.addClickListener((event) async {
      await Get.to(() => NotificationScreen());

    });

    OneSignal.InAppMessages.paused(true);
  }
}
