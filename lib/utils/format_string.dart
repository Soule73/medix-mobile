/// Formate le nom complet de l'utilisateur pour qu'il ne dépasse pas 20 caractères.
///
/// Si le nom complet est plus long que 20 caractères, il sera tronqué.
/// [fullName] Le nom complet de l'utilisateur à formater.
/// Retourne le nom complet formaté.
String formatUserFullName(String fullName) {
  return fullName.length > 20 ? fullName.substring(0, 20) : fullName;
}

/// Formate la biographie du médecin pour qu'elle ne dépasse pas 200 caractères.
///
/// Si la biographie est plus longue que 200 caractères, elle sera tronquée.
/// [fullName] La biographie du médecin à formater.
/// Retourne la biographie formatée.
String formatDoctorBio(String fullName) {
  return fullName.length > 200 ? fullName.substring(0, 200) : fullName;
}
