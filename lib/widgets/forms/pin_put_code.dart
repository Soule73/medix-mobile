import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerCompter extends GetxController {
  CountdownController controller = CountdownController(autoStart: true);

  RxBool timerDone = false.obs;
  @override
  void onClose() {
    super.onClose();
    timerDone.value = false;
  }
}

class PinPutCode extends StatelessWidget {
  PinPutCode({
    super.key,
    required this.onCompleted,
    required this.controller,
    this.reSend,
    this.title,
  });

  final TimerCompter timerCompter = Get.put(TimerCompter());

  final void Function(String code) onCompleted;
  final void Function()? reSend;
  final TextEditingController? controller;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 35,
      ),
      SizedBox(
          width: 150,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Get.theme.primaryColor, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular((100))),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/confirmed_number.svg",
              ),
            ),
          )),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title ?? "verify-your-phone-number".tr,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Get.theme.primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
                "otp-send-to-your-phone-number".tr),
          ],
        ),
      ),
      Pinput(
        length: 6,
        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
        onCompleted: onCompleted,
        controller: controller,
      ),
      Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "i-did-not-receive-any-code".tr,
            ),
            const SizedBox(width: 10),
            Obx(() => InkWell(
                onTap: timerCompter.timerDone.value ? reSend : null,
                child: timerCompter.timerDone.value
                    ? Text(
                        "resend".tr,
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.w500),
                      )
                    : TimeCountdown(timerCompter: timerCompter)))
          ]))
    ]);
  }
}

class TimeCountdown extends StatelessWidget {
  const TimeCountdown({
    super.key,
    required this.timerCompter,
  });

  final TimerCompter timerCompter;

  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: 60,
      controller: timerCompter.controller,
      build: (BuildContext context, double time) => Text(
          "${"resend-in".tr} ${time.toStringAsFixed(0)} ${"secondes".tr}",
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
      interval: const Duration(seconds: 1),
      onFinished: () => timerCompter.timerDone.value = true,
    );
  }
}
