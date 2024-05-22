import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constante pour la marge par défaut utilisée dans l'application.
const kDefaultPadding = 20.0;

/// URL de base de l'API, récupérée à partir des variables d'environnement.
String apiURL = dotenv.env['API_URL'] ?? '';

String openRouteApiKey = dotenv.env['OPEN_ROUTE_API_KEY'] ?? '';
const String applicationId = "com.sdssoum.medix";

/// URL de base pour les ressources, récupérée à partir des variables d'environnement.
String assetURL = dotenv.env['ASSET_URL'] ?? '';

/// Identifiant de l'application OneSignal, récupéré à partir des variables d'environnement.
String oneSignalAppId = dotenv.env['ONE_SIGNAL_APP_ID'] ?? '';

/// Map associant les spécialités médicales à leurs icônes correspondantes.
final Map<String, IconData> specialitiesIcon = {
  'All': Icons.groups_3_outlined,
  'Allergology': Icons.filter_vintage, // ou FontAwesomeIcons.allergies
  'Anesthesiology': Icons.local_hospital, // ou FontAwesomeIcons.procedures
  'Cardiology': Icons.favorite, // ou FontAwesomeIcons.heartbeat
  'Dermatology': Icons.texture, // ou FontAwesomeIcons.skin
  'Endocrinology': Icons.opacity, // ou FontAwesomeIcons.vial
  'Gastroenterology': Icons.restaurant_menu, // ou FontAwesomeIcons.stomach
  'Geriatrics': Icons.accessibility_new, // ou FontAwesomeIcons.user_injured
  'Gynecology': Icons.pregnant_woman, // ou FontAwesomeIcons.baby_carriage
  'Hematology': Icons.bloodtype, // ou FontAwesomeIcons.tint
  'Hepatology': Icons.local_bar, // ou FontAwesomeIcons.liver
  'Immunology': Icons.security, // ou FontAwesomeIcons.shield_virus
  'Emergency medicine': Icons.local_hospital, // ou FontAwesomeIcons.first_aid
  'General medicine':
      Icons.medical_services, // ou FontAwesomeIcons.briefcase_medical
  'Internal Medicine':
      Icons.medical_services, // ou FontAwesomeIcons.clinic_medical
  'Neonatology': Icons.child_care, // ou FontAwesomeIcons.baby
  'Nephrology': Icons.water_drop, // ou FontAwesomeIcons.kidneys
  'Neurology': Icons.psychology, // ou FontAwesomeIcons.brain
  'Oncology': Icons.local_florist, // ou FontAwesomeIcons.dna
  'Pediatrics': Icons.child_friendly, // ou FontAwesomeIcons.child
  'Pneumology': Icons.air, // ou FontAwesomeIcons.lungs
  'Psychiatry': Icons.psychology, // ou FontAwesomeIcons.head_side_virus
};
