import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/models/link_model.dart';

class Links extends StatelessWidget {
  const Links({super.key, required this.linksList, required this.onLinkClick});

  final List<Link> linksList;
  final void Function(String link) onLinkClick;
  @override
  Widget build(BuildContext context) {
    return Obx(() => linksList.isEmpty
        ? Container()
        : SizedBox(
            width: double.infinity,
            height: 40.0,
            child: Center(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: linksList.length,
                    itemBuilder: (context, index) {
                      final Link link = linksList[index];
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: TextButton(
                              style: _buttonStyle(link),
                              onPressed: () => _linkPressed(link.url),
                              child: BtnChild(link: link)));
                    }))));
  }

  ButtonStyle _buttonStyle(Link link) {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          link.active! ? primary : primary.withOpacity(0.1),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: link.active!
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.withOpacity(0.2)))),
        minimumSize: MaterialStateProperty.all<Size>(const Size(50, 0)));
  }

  _linkPressed(String? url) {
    url != null ? onLinkClick(url) : () {};
  }
}

class BtnChild extends StatelessWidget {
  const BtnChild({super.key, required this.link});

  final Link link;

  @override
  Widget build(BuildContext context) {
    return link.label!.contains("&raquo;") || link.label!.contains("&laquo;")
        ? _replaceHtmlCaractereIfExist(link.label)
        : Text(link.label!,
            style: TextStyle(color: link.active! ? white : null));
  }

  Row _replaceHtmlCaractereIfExist(String? label) {
    return Row(children: [
      label!.contains("&laquo;")
          ? const FaIcon(size: 12, FontAwesomeIcons.chevronLeft)
          : const SizedBox.shrink(),
      Text(
        label.replaceAll("&laquo;", "").replaceAll("&raquo;", ""),
      ),
      label.contains("&raquo;")
          ? const FaIcon(FontAwesomeIcons.chevronRight, size: 12)
          : const SizedBox.shrink()
    ]);
  }
}
