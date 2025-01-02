import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';

class UploadProfileImage extends StatelessWidget {
  const UploadProfileImage({super.key, required this.onSelectFile});
  final void Function(File file) onSelectFile;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _containerDecoration(),
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
            onTap: () => _showImageSourceSelection(context),
            child: FaIcon(FontAwesomeIcons.pencil,
                color: Get.theme.canvasColor, size: 20)));
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Get.theme.primaryColor.withAlpha((0.9 * 255).toInt()),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Get.theme.canvasColor, width: 2),
    );
  }

  void _showImageSourceSelection(BuildContext context) {
    bottomSheet(
        context: context,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildImageSelectionOption(context,
              icon: Icons.photo_library,
              text: "choose-from-device".tr,
              imageSource: ImageSource.gallery),
          _buildImageSelectionOption(context,
              icon: Icons.camera_alt,
              text: "to-take-a-picture".tr,
              imageSource: ImageSource.camera)
        ]));
  }

  GestureDetector _buildImageSelectionOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required ImageSource imageSource,
  }) {
    return GestureDetector(
        onTap: () => _selectImage(context, imageSource),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon),
          ),
          Text(text)
        ]));
  }

  Future<void> _selectImage(BuildContext context, ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      onSelectFile(File(pickedFile.path));
    }
    Get.back();
  }
}
