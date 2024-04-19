import 'package:medix/langs/ar/default.dart';
import 'package:medix/langs/en/default.dart';
import 'package:medix/langs/fr/default.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en": en,
    "fr": fr,
    'ar': ar
  };
}
