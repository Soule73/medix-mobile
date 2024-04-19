import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget buildFavoriteIcon({required bool isFavorite}) {
  return isFavorite
      ? const FaIcon(FontAwesomeIcons.solidHeart, color: Colors.pink)
      : SvgPicture.asset('assets/icons/heart.svg',
          colorFilter:
              ColorFilter.mode(Get.theme.primaryColor, BlendMode.srcIn));
}
