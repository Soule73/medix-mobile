import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg',
            colorFilter: ColorFilter.mode(primary, BlendMode.srcIn)),
        onPressed: onPressed ?? () => Get.back());
  }
}
