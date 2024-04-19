import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/review_rating_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/screens/profile/edit_review_screen.dart';
import 'package:medix/screens/profile/review_actions.dart';
import 'package:medix/widgets/bottom_sheet_action_item.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';
import 'package:medix/widgets/empty_result.dart';
import 'package:medix/widgets/reviews_rating.dart';

class ReviewsScreen extends StatelessWidget {
  ReviewsScreen({super.key});

  final ReviewRatingController controller = Get.put(ReviewRatingController());

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: 'my-reviews'.tr,
        leading: const BackBtn(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDoctorListOrLoading()),
        floatingActionButton: _buildFloatingActionButton());
  }

  Widget _buildFloatingActionButton() {
    return Obx(() => GestureDetector(
        onTap: () => controller.isLoad.value ? null : controller.fetchReview(),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Get.theme.primaryColor.withOpacity(0.3)),
            child: controller.isLoad.value
                ? buildLoadingIndicatorSmall(color: primary)
                : Icon(Icons.refresh, color: primary))));
  }

  Widget _buildDoctorListOrLoading() {
    return Obx(() {
      if (controller.isLoad.value) {
        return buildLoadingIndicator(height: Get.height * 0.9);
      } else if (controller.reviewsList.value.isEmpty) {
        return buildEmptyResult(height: Get.height * 0.6);
      }
      return _buildReviewList();
    });
  }

  ListView _buildReviewList() {
    return ListView.builder(
        itemCount: controller.reviewsList.value.length,
        itemBuilder: (BuildContext context, int index) {
          final review = controller.reviewsList.value[index];
          return ItemReviewWidget(
              reviewRatings: review,
              isPatientReview: true,
              onTapAction: () {
                bottomSheet(context: context, child: _actions(review));
              });
        });
  }

  Widget _actions(Review review) {
    return reviewAction(
        onTapUpdate: () => Get.to(() => EditReviewScreen(review: review)),
        onTapDelete: () async => await controller.deleteReview(review: review));
  }
}
