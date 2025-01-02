import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/lang_controller.dart';
import 'package:medix/controllers/location_controller.dart';
import 'package:medix/controllers/one_signal.dart';
import 'package:medix/screens/auth/login/login_screen.dart';

import '../widgets/boutons/button.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({super.key});

  final IntroductionController introCtrl = Get.put(IntroductionController());
  void _onIntroEnd() {
    Get.to(LoginScreen());
    Get.find<Auth>().setIsFisrtOpenApp();
  }

  Widget _buildImage(String assetName, [double? width]) {
    return SvgPicture.asset(assetName, width: width ?? Get.width * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 60, top: 50),
        child: IntroductionScreen(
            key: introCtrl.introKey,
            globalBackgroundColor: Get.isDarkMode ? darkBg : Colors.white,
            pages: [
              PageViewModel(
                title: "welcome-to-medix".tr,
                body: "book-appointment-one-click".tr,
                image: _buildImage('assets/icons/medicine.svg'),
              ),
              _pageView(
                  title: "for-find-a-doctor-location".tr,
                  image: 'assets/icons/current_location.svg',
                  body:
                      "for-find-a-doctor-location-location-permission-required"
                          .tr,
                  subTitle: "location-not-used-background".tr.tr,
                  permissionBtn: FadeBtn(
                      height: 40,
                      title: 'Activer la localisation'.tr,
                      onPressed: _handleLocationPermission,
                      color: primary),
                  onDenid: () => introCtrl.introKey.currentState?.next()),
              _pageView(
                  title: "notifications".tr,
                  image: 'assets/svg/notification_ullustration.svg',
                  body: "for-receive-realtime-notifications".tr.tr,
                  subTitle: "please-guaranted-notifications-permission".tr,
                  permissionBtn: FadeBtn(
                      height: 40,
                      title: 'guaranted-notifications'.tr,
                      onPressed: _handlePromptForPushPermission,
                      color: primary),
                  onDenid: _onIntroEnd),
            ],
            onDone: () => _onIntroEnd(),
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: false,
            rtl: Get.find<LangController>().lang.value ==
                "ar", // Display as right-to-left
            back: const Icon(Icons.arrow_back),
            next: const Icon(Icons.arrow_forward),
            done: Text("log-in-or-sign-up".tr,
                style: const TextStyle(fontWeight: FontWeight.w600))));
  }

  void _handlePromptForPushPermission() {
    Get.find<OneSignalNotification>().handlePromptForPushPermission();
    _onIntroEnd.call();
  }

  void _handleLocationPermission() async {
    await Get.find<LocationController>().handleLocationPermission();
    introCtrl.introKey.currentState?.next();
  }

  PageViewModel _pageView(
      {required String title,
      required String body,
      required String image,
      required String subTitle,
      Widget? permissionBtn,
      void Function()? onDenid}) {
    return PageViewModel(
        title: title,
        bodyWidget: Text(body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
        image: _buildImage(image),
        footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Text(textAlign: TextAlign.center, subTitle)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                    width: 130,
                    child: OutlinedBtn(
                        height: 40, title: "no-thanks".tr, onPressed: onDenid)),
                SizedBox(width: 210, child: permissionBtn)
              ])
            ])));
  }
}

class IntroductionController extends GetxController {
  final introKey = GlobalKey<IntroductionScreenState>();
}
