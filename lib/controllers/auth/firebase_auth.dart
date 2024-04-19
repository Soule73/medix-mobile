import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';

/// La fonction " firebaseSignOutUser " déconnecte l'utilisateur actuel de l'authentification Firebase
/// s'il est connecté.
Future<void> firebaseSignOutUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    await auth.signOut();
  }
}

/// La fonction " firebaseDestroyUser " supprime l'image d'avatar d'un utilisateur de Firebase Storage,
/// puis supprime le compte de l'utilisateur de Firebase Authentication si l'utilisateur est
/// actuellement connecté.
Future<void> firebaseDestroyUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  try {
    if (auth.currentUser != null) {
      String? avatar = Get.find<Auth>().user.value?.avatar;
      if (avatar != null && avatar.contains('firebasestorage')) {
        final desertRef =
            storage.refFromURL('${Get.find<Auth>().user.value?.avatar}');
        await desertRef.delete();

        await auth.currentUser?.delete();

        await auth.signOut();
      }
    }
  } catch (_) {}
}
