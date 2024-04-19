import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:path/path.dart' as p;

/// Contrôleur pour la mise à jour du profil utilisateur.
///
/// Permet aux utilisateurs de mettre à jour leurs informations de profil, y compris
/// le nom, l'adresse, le sexe, la ville et la date de naissance. Utilise le package GetX
/// pour la gestion d'état et Firebase pour le stockage des données.
class UpdateProfileController extends GetxController {
  /// Contrôleur pour le prénom de l'utilisateur.
  final TextEditingController userUpdateFirstName =
      TextEditingController(text: Get.find<Auth>().user.value?.firstName ?? '');

  /// Contrôleur pour le nom de famille de l'utilisateur.
  final TextEditingController userUpdateLastName =
      TextEditingController(text: Get.find<Auth>().user.value?.name ?? '');

  /// Contrôleur pour l'adresse de l'utilisateur.
  final TextEditingController userUpdateAddress =
      TextEditingController(text: Get.find<Auth>().user.value?.addresse ?? '');

  /// Contrôleur pour le sexe de l'utilisateur.
  final TextEditingController userUpdateSex =
      TextEditingController(text: Get.find<Auth>().user.value?.sex ?? '');

  /// Contrôleur pour la ville de l'utilisateur.
  final TextEditingController userUpdateCity = TextEditingController(
      text: Get.find<Auth>().user.value?.cityId.toString() ?? '');

  /// Observable pour la date de naissance de l'utilisateur.
  Rx<DateTime?> userUpdateBirthday =
      (Get.find<Auth>().user.value?.birthday != null)
          ? DateTime.parse(Get.find<Auth>().user.value!.birthday!).obs
          : Rx<DateTime?>(null);

  /// Observable pour l'état de la mise à jour du profil.
  RxBool isSetUserProfile = false.obs;

  /// Observable pour l'état de progression du téléchargement.
  RxString progressState = 'upload-pending'.tr.obs;

  /// Définit l'état de progression du téléchargement.
  ///
  /// [val] Le nouvel état de progression.
  void setProgress(String val) => progressState.value = val;

  /// Nettoie les contrôleurs lors de la fermeture du contrôleur.
  @override
  void onClose() {
    super.onClose();
    userUpdateFirstName.dispose();
    userUpdateLastName.dispose();
    userUpdateAddress.dispose();
  }

  /// Met à jour les informations de l'utilisateur.
  ///
  /// [user] Un map contenant les nouvelles informations de l'utilisateur.
  /// Retourne `void`.
  Future<void> updateUserInfo() async {
    Map<String, dynamic> user = {
      'name': userUpdateLastName.text,
      'first_name': userUpdateFirstName.text,
      'city_id': userUpdateCity.text,
      'birthday': userUpdateBirthday.value.toString(),
      'sex': userUpdateSex.text,
      'addresse': userUpdateAddress.text
    };
    await Get.find<Auth>().updateUser(credential: user);
  }

  /// Met à jour l'avatar de l'utilisateur.
  ///
  /// [file] Le fichier contenant la nouvelle image de profil.
  /// Retourne `void`.
  Future<void> updateUserAvatar(File file) async {
    isSetUserProfile.value = true;
    String? url = await uploadFile(file);
    try {
      if (url != null) {
        Map<String, dynamic> user = {
          'avatar': url,
        };
        await Get.find<Auth>()
            .updateUser(credential: user, path: '/auth/user/update/avatar');
      } else {
        errorDialog(
            title: 'something-went-wrong-title'.tr,
            body: 'something-went-wrong-try'.tr);
      }
    } catch (e) {
      defaultErrorDialog();
      if (kDebugMode) {
        print(e);
      }
    }
    isSetUserProfile.value = false;
  }

  /// Télécharge un fichier sur Firebase Storage.
  ///
  /// [file] Le fichier à télécharger.
  /// Retourne `String?` qui est l'URL du fichier téléchargé ou `null` en cas d'échec.
  Future<String?> uploadFile(File file) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String? uid;
    if (auth.currentUser != null) {
      uid = auth.currentUser?.uid;
    } else {
      uid = '${Get.find<Auth>().user.value?.id}';
    }

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      String? avatar = Get.find<Auth>().user.value?.avatar;
      if (avatar != null && avatar.contains('firebasestorage')) {
        final desertRef = storage.refFromURL(avatar);
        await desertRef.delete();
      }
      final fileExtension = p.extension(file.path);

      /// Le code Dart ci-dessus crée une référence à un emplacement dans le stockage Firebase. Il spécifie le
      /// chemin d'accès à un fichier dans le bucket de stockage à l'aide de la méthode " enfant ". Le chemin
      /// est construit à l'aide des variables " uid " et " fileExtension ", qui sont probablement utilisées
      /// pour identifier de manière unique le fichier.
      Reference ref = storage.ref().child('profile_images/$uid$fileExtension');

      /// Le code Dart ci-dessus crée un objet " UploadTask " en téléchargeant un fichier vers un emplacement
      /// spécifié. La méthode `putFile` est utilisée pour télécharger le `fichier` avec des métadonnées
      /// supplémentaires fournies à l'aide de `SettableMetadata`. Dans ce cas, le type de contenu du fichier
      /// est défini en fonction de l'extension du fichier.
      UploadTask uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: "image/${p.extension(file.path).replaceAll('.', '')}",
          ));

      /// Le code Dart ci-dessus configure un écouteur pour les événements d'instantané d'une tâche de
      /// téléchargement. En fonction de l'état de l'instantané de la tâche, différentes actions sont
      /// entreprises :
      /// - Si la tâche est en cours d'exécution, elle calcule le pourcentage de progression et met à jour le
      /// message de progression.
      /// - Si la tâche est en pause, il définit le message de progression pour indiquer que la tâche est
      /// suspendue.
      /// - Si la tâche est annulée, il définit le message de progression pour indiquer que la tâche est
      /// annulée.
      /// - Si la tâche rencontre une erreur, elle définit le message de progression pour indiquer une erreur
      /// et définit un indicateur booléen `isSetUserProfile` sur true.
      /// -
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            {
              var progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              setProgress("${progress.toStringAsFixed(2)}% ${"finished".tr}.");
              break;
            }
          case TaskState.paused:
            {
              setProgress("suspended".tr);
              break;
            }
          case TaskState.canceled:
            {
              setProgress("canceled".tr);
              break;
            }
          case TaskState.error:
            {
              setProgress("error".tr);
              break;
            }
          case TaskState.success:
            {
              setProgress("completed".tr);
              break;
            }
        }
      });
      String url = await (await uploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
