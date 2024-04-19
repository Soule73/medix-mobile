import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

void openBottomSheetSpecility(
    {required BuildContext context,
    required Widget children,
    required Widget title,
    Function? onComplete,
    Widget? footer}) {
  showModalBottomSheet(
    backgroundColor: Get.theme.canvasColor,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return DraggableScrollableSheet(
          maxChildSize: 0.75,
          initialChildSize: 0.55,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
                padding: const EdgeInsets.only(bottom: 45),
                child: Stack(children: [
                  CustomScrollView(controller: scrollController, slivers: [
                    SliverAppBar(
                        shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        automaticallyImplyLeading: false,
                        floating: true,
                        pinned: true,
                        backgroundColor: primary,
                        title: Center(child: title)),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                                  child: children,
                                ),
                            childCount: 1))
                  ]),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          decoration:
                              BoxDecoration(color: Get.theme.canvasColor),
                          child: footer))
                ]));
          });
    },
  ).whenComplete(() {
    onComplete?.call();
  });
}
