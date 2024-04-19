import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/utils/utils.dart';

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    super.key,
    required this.avatar,
    required this.phone,
    required this.fullName,
    required this.email,
    required this.title,
    required this.tags,
    this.isHero = true,
  });

  final String avatar;
  final String phone;
  final String fullName;
  final String email;
  final String title;
  final int? tags;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    return Row(children: [_buildAvatar(context), _buildDoctorDetails()]);
  }

  Widget _buildAvatar(BuildContext context) {
    return SizedBox(
        width: Get.width / 3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: isHero
                ? Hero(
                    tag: tags!,
                    child:
                        Image.network(networkImage(avatar), key: UniqueKey()))
                : Image.network(networkImage(avatar), key: UniqueKey())));
  }

  Widget _buildDoctorDetails() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(fullName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              _buildTitleUnderline(),
              Text(phone, style: TextStyle(color: Get.theme.dividerColor)),
              Text(email, style: TextStyle(color: Get.theme.dividerColor))
            ])));
  }

  Widget _buildTitleUnderline() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Get.theme.dividerColor))),
        child: Text(title, style: const TextStyle(fontSize: 16)));
  }
}
