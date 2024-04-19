import 'package:get/get.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrôleur pour la gestion des médecins favoris de l'utilisateur.
///
/// Permet aux utilisateurs de gérer leur liste de médecins favoris et de récupérer
/// cette liste depuis les préférences partagées. Utilise le package GetX pour la
/// gestion d'état.
class FavorisController extends GetxController {
  /// Liste observable des identifiants des médecins favoris.
  RxList<String> favorisList = RxList<String>();

  /// Instance de l'API pour les requêtes concernant les médecins.
  ApiDoctor apiDoctor = ApiDoctor();

  /// Observable pour l'état de chargement des médecins favoris.
  RxBool isLoadingFavoris = false.obs;

  /// Liste observable des médecins favoris de l'utilisateur.
  Rx<List<Doctor>> userFavrisDoctors = Rx<List<Doctor>>([]);

  /// Initialisation du contrôleur.
  ///
  /// Charge la liste des favoris depuis les préférences partagées.
  @override
  void onInit() async {
    super.onInit();

    var prefs = await SharedPreferences.getInstance();

    List<String>? favori = prefs.getStringList('patientDoctorFavori');

    favorisList.value = favori ?? [];
  }

  /// Ajoute ou supprime un médecin de la liste des favoris.
  ///
  /// [doctorId] L'identifiant du médecin à ajouter ou supprimer.
  /// Retourne `void`.
  Future<void> addOrDeleteFavori(String doctorId) async {
    var prefs = await SharedPreferences.getInstance();

    if (favorisList.contains(doctorId)) {
      favorisList.remove(doctorId);
    } else {
      favorisList.add(doctorId);
    }
    await prefs.setStringList('patientDoctorFavori', favorisList);
  }

  /// Récupère la liste des médecins favoris de l'utilisateur.
  ///
  /// Retourne `void`.
  Future<void> getFavris() async {
    if (favorisList.isNotEmpty) {
      isLoadingFavoris.value = true;

      userFavrisDoctors.value =
          await apiDoctor.fetchFavoris(favoris: favorisList);
      isLoadingFavoris.value = false;
    }
  }
}
