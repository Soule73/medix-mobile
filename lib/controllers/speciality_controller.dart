import 'package:get/get.dart';
import 'package:medix/models/specility_model.dart';
import 'package:medix/services/api_speciality.dart';

/// Contrôleur pour la gestion des spécialités médicales.
///
/// Permet de récupérer et d'afficher la liste des spécialités médicales disponibles.
/// Utilise le package GetX pour la gestion d'état.
class SpecialityController extends GetxController {
  /// Observable pour l'état de chargement des spécialités.
  RxBool isLoadingSpecialitys = false.obs;

  /// Initialisation du contrôleur.
  ///
  /// Lance la récupération des spécialités dès l'initialisation du contrôleur.
  @override
  void onInit() {
    super.onInit();
    fetchSpecialities();
  }

  /// Instance de l'API pour les requêtes concernant les spécialités.
  final ApiSpeciality apiSpeciality = ApiSpeciality();

  /// Liste observable des spécialités avec une spécialité 'All' par défaut.
  RxList<Speciality> specialitysList = [Speciality(id: 2000, name: "All")].obs;

  /// Récupère les spécialités médicales.
  ///
  /// Ajoute une spécialité 'All' par défaut et fusionne la liste récupérée avec celle-ci.
  /// Gère l'état de chargement pendant la récupération des données.
  /// Retourne `void`.
  Future<void> fetchSpecialities() async {
    isLoadingSpecialitys.value = true;
    try {
      specialitysList.value = [Speciality(id: 2000, name: "All")];
      List<Speciality> newSpecialitysList =
          await apiSpeciality.fetchSpecialities();
      specialitysList.value = [...specialitysList, ...newSpecialitysList];
      isLoadingSpecialitys.value = false;
    } catch (e) {
      isLoadingSpecialitys.value = false;
    }
  }
}
