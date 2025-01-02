import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/constants.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.tap,
  });

  final GestureTapCallback tap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding),
        child: GestureDetector(
            onTap: tap,
            child: Container(
                decoration: _decoration(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin:
                    const EdgeInsets.only(bottom: 20, left: 8.0, right: 8.0),
                child: SvgPicture.asset('assets/icons/filter.svg',
                    colorFilter: ColorFilter.mode(
                        Get.theme.primaryColor, BlendMode.srcIn)))));
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
        border: Border.all(
            color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt())),
        borderRadius: BorderRadius.circular(10));
  }
}
