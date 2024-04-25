import 'package:get/get.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/qualification_model.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/services/api_doctor.dart';

/// Contrôleur pour la gestion des médecins dans l'application.
///
/// Permet de récupérer la liste des médecins, leurs détails, et de gérer les filtres
/// de recherche par spécialité. Utilise le package GetX pour la gestion d'état.
class DoctorController extends GetxController {
  /// Initialisation du contrôleur.
  ///
  /// Lance la récupération des médecins dès l'initialisation du contrôleur.
  @override
  void onInit() async {
    await fetchDoctors();
    super.onInit();
  }

  /// Instance de l'API pour les requêtes concernant les médecins.
  final ApiDoctor apiDoctor = ApiDoctor();

  /// Valeur par défaut pour représenter toutes les spécialités.
  static String all = "2000";

  /// Observable pour la recherche par nom ou spécialité.
  RxString search = "".obs;

  /// Observable pour l'état de chargement de la liste des médecins.
  RxBool isLoadingDoctors = false.obs;

  /// Observable pour l'état de chargement des détails d'un médecin.
  RxBool isLoadingDoctorDetail = false.obs;

  /// Observable pour l'identifiant de la spécialité actuellement sélectionnée.
  RxString currentSpecialityId = "2000".obs;

  /// Définit la valeur de recherche.
  ///
  /// [value] La nouvelle valeur pour la recherche.
  void setSearch(String value) => search.value = value.trim();

  /// Liste observable des médecins.
  Rx<List<Doctor>> doctorsList = Rx<List<Doctor>>([]);

  /// Liste observable des médecins en vedette.
  Rx<List<Doctor>> topDoctorsList = Rx<List<Doctor>>([]);

  /// Liste observable des liens de pagination.
  RxList<Link> linksList = <Link>[].obs;

  /// Liste observable des évaluations et commentaires.
  Rx<List<Review>> reviewRatings = Rx<List<Review>>([]);

  /// Liste observable des qualifications du médecin.
  Rx<List<Qualification>> qualificationList = Rx<List<Qualification>>([]);

  /// Horaire hebdomadaire observable du médecin sélectionné.
  Rx<WeeklySchedule?> weeklySchedule = Rx<WeeklySchedule?>(null);

  /// Liste observable des filtres de spécialité.
  RxList<String> specialitiesListFilter = <String>[all].obs;

  /// Définit l'état de chargement de la liste des médecins.
  ///
  /// [newValue] Le nouvel état de chargement.
  void setIsLoadingDoctors(bool newValue) => isLoadingDoctors.value = newValue;

  /// Récupère la liste des médecins.
  ///
  /// [url] L'URL optionnelle pour la pagination.
  /// Retourne `void`.
  Future<void> fetchDoctors([String? url]) async {
    setIsLoadingDoctors(true);
    try {
      List<String>? specialitiesFilter = specialitiesListFilter.contains(all) ||
              currentSpecialityId.value != "2000"
          ? []
          : specialitiesListFilter;
      final List<Doctor> result = await apiDoctor.fetchDoctors(
          search: search.value,
          specialitiesIds: specialitiesFilter,
          urlFetch: url,
          specialityId: currentSpecialityId.value != "2000"
              ? currentSpecialityId.value
              : '');
      doctorsList.value = result;
      if (specialitiesFilter.isEmpty && currentSpecialityId.value == "2000") {
        topDoctorsList.value = result;
      }

      setIsLoadingDoctors(false);
    } catch (e) {
      setIsLoadingDoctors(false);
    }
  }

  /// Récupère les détails d'un médecin.
  ///
  /// [doctorId] L'identifiant du médecin.
  /// Retourne `void`.
  Future<void> fetchDoctorDetails(String doctorId) async {
    isLoadingDoctorDetail.value = true;
    weeklySchedule.value = null;
    reviewRatings.value = [];
    await apiDoctor.fetchDoctorDetails(doctorId: doctorId);
    isLoadingDoctorDetail.value = false;
  }

  /// Ajoute ou supprime une spécialité dans le filtre.
  ///
  /// [id] L'identifiant de la spécialité à ajouter ou supprimer.
  /// Retourne `void`.
  void addOrDeleteInSpecialityFilter(String id) {
    if (id == all) {
      specialitiesListFilter.value = [all];
    } else {
      if (specialitiesListFilter.contains(all)) {
        specialitiesListFilter.remove(all);
      }
      if (specialitiesListFilter.contains(id)) {
        specialitiesListFilter.remove(id);
      } else {
        specialitiesListFilter.add(id);
      }
      if (specialitiesListFilter.isEmpty) {
        specialitiesListFilter.add(all);
      }
    }
  }
}
