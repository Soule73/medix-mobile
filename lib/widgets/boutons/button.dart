import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

class FadeBtn extends StatelessWidget {
  const FadeBtn(
      {super.key,
      this.onPressed,
      required this.title,
      this.width,
      this.height,
      this.color,
      this.isLoad = false,
      this.fontSize,
      this.radius = 25});

  final void Function()? onPressed;
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final bool isLoad;
  final double? fontSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          isLoad
              ? Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  child: CircularProgressIndicator(
                      color: Get.theme.primaryColor, strokeWidth: 3))
              : const SizedBox.shrink(),
          Text(title, style: TextStyle(fontSize: fontSize, color: Colors.white))
        ]));
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
        backgroundColor: _btnBackgroundColor(color ?? primary),
        shape: _btnShape(radius),
        minimumSize: _btnMinimumSize(width, height));
  }
}

WidgetStateProperty<Size?>? _btnMinimumSize(double? width, double? height) =>
    WidgetStateProperty.all<Size>(
      Size(width ?? Get.width * 0.6, height ?? 50),
    );
WidgetStateProperty<OutlinedBorder?>? _btnShape(double radius) =>
    WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
WidgetStateProperty<Color?>? _btnBackgroundColor(Color color) =>
    WidgetStateProperty.all<Color>(
      color,
    );

class OutlinedBtn extends StatelessWidget {
  const OutlinedBtn(
      {super.key,
      this.onPressed,
      required this.title,
      this.width,
      this.height,
      this.color,
      this.isLoad = false,
      this.fontSize,
      this.radius = 25});

  final void Function()? onPressed;
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final bool isLoad;
  final double? fontSize;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          isLoad
              ? Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  child: CircularProgressIndicator(
                    color: Get.theme.primaryColor,
                    strokeWidth: 3,
                  ))
              : const SizedBox.shrink(),
          Text(title, style: TextStyle(fontSize: fontSize))
        ]));
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
        backgroundColor: _btnBackgroundColor(Get.theme.cardColor),
        shape: _btnShape(radius),
        side: WidgetStatePropertyAll(
            BorderSide(width: 1, color: color ?? primary)),
        minimumSize: _btnMinimumSize(width, height));
  }
}
