import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/appointment_controller.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/controllers/lang_controller.dart';
import 'package:medix/controllers/location_controller.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/controllers/one_signal.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/langs/app_translation.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/themes/theme_controller.dart';
import 'package:medix/firebase_options.dart';
import 'package:medix/screens/auth/login/login_screen.dart';
import 'package:medix/screens/welcome_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  Get.put(LangController(), permanent: true);
  Get.put(Auth(), permanent: true);
  Get.put(DoctorController(), permanent: true);
  Get.put(SpecialityController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(FavorisController(), permanent: true);
  Get.put(AppointmentController(), permanent: true);
  Get.put(OneSignalNotification(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.lazyPut(() => AppointmentDetailController(), fenix: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Get.isDarkMode ? darkBg : primary,
  ));

  runApp(const MainApp());
}

ThemeData _darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: white,
  colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: white,
      surface: darkBg),
);

ThemeData _lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: darkBlue,
  colorScheme: ColorScheme.fromSeed(
      surface: lightBg,
      seedColor: primary,
      brightness: Brightness.light,
      primary: darkBlue),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Get.find<LangController>().appLang,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetMaterialApp(
              translationsKeys: AppTranslation.translationsKeys,
              locale: snapshot.data,
              fallbackLocale: const Locale('en'),
              debugShowCheckedModeBanner: false,
              theme: _lightTheme,
              darkTheme: _darkTheme,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('fr'),
                Locale('ar'),
              ],
              themeMode: Get.find<ThemeController>().themeMode.value,
              home: Obx(() => Get.find<Auth>().authenticated.value
                  ? WelcomeScreen()
                  : LoginScreen()),
            );
          } else {
            return Center(child: CircularProgressIndicator(color: primary));
          }
        });
  }
}
