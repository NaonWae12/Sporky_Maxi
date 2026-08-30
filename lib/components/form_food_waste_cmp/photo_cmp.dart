import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sporky_maxi/components/globals/button/globals_button.dart';
import 'package:sporky_maxi/components/globals/card/globals_card.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';

class PhotoCmp extends StatefulWidget {
  final ValueChanged<XFile>? onPhotoSelected;

  const PhotoCmp({super.key, this.onPhotoSelected});

  @override
  State<PhotoCmp> createState() => _PhotoCmpState();
}

class _PhotoCmpState extends State<PhotoCmp> {
  XFile? _photo;

  Future<void> _pickPhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _photo = pickedFile;
    });
    widget.onPhotoSelected?.call(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        GestureDetector(
          onTap: _pickPhoto,
          child: GlobalsCard(
            backgroundColor: AppColors.base4,
            height: 343,
            width: 343,
            child: _photo == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        size: 36,
                        color: AppColors.primary1,
                      ),
                      Text(
                        'Buka Galeri',
                        style: AppTextStyles.list1Regular(AppColors.primary1),
                      ),
                    ],
                  )
                : Image.file(fit: BoxFit.cover, File(_photo!.path)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Pastikan foto diambil dari atas dan pencahayaan cukup agar hasil analisis lebih akurat ya, Bunda!',
          ),
        ),
        const SizedBox(height: 15),
        GlobalsButton(
          width: MediaQuery.of(context).size.width / 1.1,
          onPressed: _pickPhoto,
          text: 'Upload Foto Sisa Makanan',
          color: AppColors.secondary1,
          textColor: AppColors.base5,
        ),
      ],
    );
  }
}
