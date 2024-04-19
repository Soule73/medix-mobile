import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/utils/format_string.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/buil_rate.dart';

class ItemReviewWidget extends StatelessWidget {
  const ItemReviewWidget({
    super.key,
    required this.reviewRatings,
    this.isPatientReview = false,
    this.onTapAction,
  });

  final Review reviewRatings;
  final bool isPatientReview;
  final void Function()? onTapAction;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Get.theme.primaryColor.withOpacity(0.1)),
        child: Column(children: [
          Row(children: [_header(), _body()]),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('${reviewRatings.comment}')),
          Row(children: [
            ...builRate(reviewRatings.star),
            Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(timeFromNow(reviewRatings.createdAt!)))
          ])
        ]));
  }

  Expanded _body() {
    return Expanded(
        flex: 6,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  formatUserFullName(isPatientReview
                      ? '${reviewRatings.doctorFullname}'
                      : '${reviewRatings.patientFullname}'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700))),
          isPatientReview
              ? GestureDetector(
                  onTap: onTapAction,
                  child: const Icon(Icons.more_horiz_outlined, size: 25))
              : const SizedBox.shrink()
        ]));
  }

  Expanded _header() {
    return Expanded(
        flex: 1,
        child: SizedBox(
            width: 50,
            height: 50,
            child: reviewRatings.patientAvatar != null
                ? _avaTarIfExist()
                : _defaultAvatar()));
  }

  CircleAvatar _defaultAvatar() {
    return CircleAvatar(
        child: ClipOval(
            child: SvgPicture.asset('assets/icons/avatar.svg',
                fit: BoxFit.scaleDown)));
  }

  CircleAvatar _avaTarIfExist() {
    return CircleAvatar(
        backgroundColor: primary,
        backgroundImage: NetworkImage(networkImage(isPatientReview
            ? '${reviewRatings.doctorAvatar}'
            : '${reviewRatings.patientAvatar}')));
  }
}
