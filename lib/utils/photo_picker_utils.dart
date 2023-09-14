import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialog_utils.dart';

class PhotoPickerUtils {
  static double maxWidth = 0;
  static int imageQuality = 0;
  static Future<File>? pickPhoto(
    BuildContext context, {
    double maxWidth = 0,
    int imageQuality = 0,
    bool cameraOnly = false,
    bool galleryOnly = false,
  }) {
    PhotoPickerUtils.maxWidth = maxWidth;
    PhotoPickerUtils.imageQuality = imageQuality;
    if (cameraOnly) {
      return _pickImageAction(context, ImageSource.camera);
    } else if (galleryOnly) {
      return _pickImageAction(context, ImageSource.gallery);
    } else {
      return _pickImageActionSheet(context);
    }
  }

  static Future<List<Asset>> pickMultiPhotos({
    int maxImages = 1,
    List<Asset> selectedAssets = const [],
  }) async {
    return await MultiImagePicker.pickImages(
      maxImages: maxImages,
      enableCamera: true,
      selectedAssets: selectedAssets,
      materialOptions: MaterialOptions(
        actionBarTitle: "鲸轿洗车",
        allViewTitle: "全部图片",
        useDetailsView: false,
        selectCircleStrokeColor: "#000000",
        selectionLimitReachedText: "选择图片数量已达上限",
      ),
    );
  }

  static Future<File> _pickImageActionSheet(BuildContext context) async {
    var result = await DialogUtils.showActionSheetDialog(
      context,
      dialogItems: [
        ActionSheetDialogItem(title: '拍照', result: 1),
        ActionSheetDialogItem(title: '我的相册', result: 2),
      ],
    );
    if (result == 1) {
      return _pickImageAction(context, ImageSource.camera);
    } else {
      return _pickImageAction(context, ImageSource.gallery);
    }
  }

  static Future<File> _pickImageAction(
      BuildContext context, ImageSource source) async {
    late File fileImage;
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );
      fileImage = File(pickedFile!.path);
    } catch (error) {
      print(error);
    }
    return fileImage;
  }

  static Future<bool> requestPermission(
      BuildContext context, ImageSource source) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.granted) {
      return true;
    } else {
      String errorMsg = source == ImageSource.camera
          ? "调用相机出错，请确保是否打开相机权限"
          : "调用相册出错，请确保是否打开相册权限";
      DialogUtils.showAlertDialog(
        context,
        message: errorMsg,
        confirmAction: () {},
      );
      return false;
    }
  }
}
