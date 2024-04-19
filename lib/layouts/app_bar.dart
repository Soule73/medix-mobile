import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar buildAppBar(BuildContext context,
    {String? title,
    required List<Widget> actions,
    Widget? leading,
    Widget? titleWidget}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: titleWidget != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: titleWidget,
                ),
              ),
            ],
          )
        : Text(
            title ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
    centerTitle: true,
    leading: leading,
    actions: titleWidget != null ? null : actions,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
