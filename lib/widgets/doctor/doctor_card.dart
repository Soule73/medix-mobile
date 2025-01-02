import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/screens/doctor/doctor_detail_screen.dart';
import 'package:medix/utils/format_string.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/is_favorite.dart';
import 'package:medix/widgets/speciality_badge.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    this.onTap,
    required this.isFavorite,
    required this.doctor,
  });

  final void Function()? onTap;
  final bool isFavorite;
  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _handleCardTap(context),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt())),
            child: Row(children: [
              _buildAvatar(doctor),
              _buildDoctorDetails(context)
            ])));
  }

  void _handleCardTap(BuildContext context) {
    int? doctorId = doctor.id;
    if (doctorId != null) {
      Get.find<DoctorController>().fetchDoctorDetails(doctorId);
    }
    Get.to(() => DoctorDetailScreen(doctor: doctor));
  }

  Widget _buildAvatar(Doctor doctor) {
    return Expanded(
        flex: 1,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Hero(
                tag: doctor.id!,
                child: Image.network(
                    key: UniqueKey(),
                    networkImage('${doctor.avatar}'),
                    loadingBuilder: _loadingBuilder,
                    errorBuilder: _errorBuilder))));
  }

  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return const Center(
        child: Icon(
      Icons.image,
      size: 65,
    ));
  }

  Widget _loadingBuilder(context, child, loadingProgress) {
    if (loadingProgress == null) {
      return child;
    } else {
      return Center(
          child: SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                      color: primary, strokeWidth: 2.0))));
    }
  }

  Widget _buildDoctorDetails(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Container(
            margin: const EdgeInsets.only(left: 8, top: 8.0),
            width: double.infinity,
            child: _buildDoctorInfo(doctor)));
  }

  Widget _buildDoctorInfo(Doctor doctor) {
    return Column(children: [
      _buildDoctorName(doctor),
      _buildSpecialityBadge(doctor),
      _buildRating(doctor)
    ]);
  }

  Widget _buildDoctorName(Doctor doctor) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(formatUserFullName('${doctor.fullname}'),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 18)))),
      GestureDetector(
          onTap: onTap, child: buildFavoriteIcon(isFavorite: isFavorite))
    ]);
  }

  Widget _buildSpecialityBadge(Doctor doctor) {
    List<String>? specialities = doctor.specialities;
    if (specialities != null) {
      return SpecialityBadge(specialities: specialities);
    }
    return const SizedBox.shrink();
  }

  Widget _buildRating(Doctor doctor) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Row(children: [
          FaIcon(FontAwesomeIcons.solidStar, color: primary, size: 15),
          Text(' ${doctor.ratings} ')
        ]));
  }
}
