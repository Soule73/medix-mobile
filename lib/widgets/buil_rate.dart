import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medix/constants/couleurs.dart';

List<Widget> builRate(int? star) {
  if (star != null && star > 0) {
    return <Widget>[
      for (int i = 0; i < star; i++)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: FaIcon(FontAwesomeIcons.solidStar, color: primary, size: 15))
    ];
  }
  return [];
}
