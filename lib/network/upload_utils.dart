import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../utils/toast_utils.dart';

import 'http_utils.dart';
import 'result_data.dart';

class UploadUtils {
  static const String UPLOAD = 'upload';

  static Future<PhotoModel?> uploadPhoto(File imageFile) async {
    print(imageFile.path);
    Map<String, dynamic> fileMap = {
      'imgFile': await MultipartFile.fromFile(
        imageFile.path,
        contentType: MediaType("image", 'jpeg'),
      ),
    };
    FormData formData = FormData.fromMap(fileMap);

    ResultData resultData =
        await HttpUtils.request('upload.do', method: UPLOAD, params: formData);
    if (resultData.isSuccessful) {
      PhotoModel photo = PhotoModel.fromJson(resultData.data);
      return photo;
    } else {
      ToastUtils.showError(resultData.msg??'未知错误');
    }
    return null;
  }

  static Future uploadMultiPhoto(
      List<Asset> imageAssets,
      Function(List<PhotoModel> photoList) onSuccess,
      Function(String msg) onError) async {
    List<PhotoModel> photoList = [];
    bool hasError = false;
    for (Asset asset in imageAssets) {
      Map<String, dynamic> imageDataMap = Map();
      int assetWidth = asset.originalWidth??0;
      double assetHeight = 0;
      if (assetWidth > 750) assetWidth = 750;
      assetHeight = assetWidth * (asset.originalHeight??0) / (asset.originalWidth??1);
      ByteData byteData =
          await asset.getThumbByteData(assetWidth, assetHeight.toInt());
      List<int> imageData = byteData.buffer.asUint8List();

      imageDataMap['imgFile'] = MultipartFile.fromBytes(
        imageData,
        filename: "image.jpg",
        contentType: MediaType("image", 'jpeg'),
      );

      FormData formData = FormData.fromMap(imageDataMap);

      ResultData resultData = await HttpUtils.request('upload.do',
          method: UPLOAD, params: formData);
      if (resultData.isSuccessful) {
        PhotoModel photo = PhotoModel.fromJson(resultData.data);
        photoList.add(photo);
      } else {
        ToastUtils.showError(resultData.msg??'未知错误');
        hasError = true;
        onError(resultData.msg??'未知错误');
        break;
      }
    }
    if (!hasError) {
      onSuccess(photoList);
    }
  }

  static Future<List<PhotoModel>> uploadPhotos(List<Asset> imageAssets) async {
    Map<String, dynamic> imageDataMap = Map();
    for (int i = 0; i < imageAssets.length; i++) {
      Asset asset = imageAssets[i];
      int assetWidth = asset.originalWidth??0;
      double assetHeight = 0;
      if (assetWidth > 750) assetWidth = 750;
      assetHeight = assetWidth * (asset.originalHeight??0) / (asset.originalWidth??1);
      ByteData byteData =
          await asset.getThumbByteData(assetWidth, assetHeight.toInt());
      List<int> imageData = byteData.buffer.asUint8List();

      imageDataMap['upload_file[$i]'] = MultipartFile.fromBytes(
        imageData,
        filename: "image.jpg",
        contentType: MediaType("image", 'jpeg'),
      );
    }

    FormData formData = FormData.fromMap(imageDataMap);
    ResultData resultData =
        await HttpUtils.request('upload.do', method: UPLOAD, params: formData);
    if (resultData.isSuccessful) {
      var photoList = resultData.data["photos"];
      List<PhotoModel> photoModelList = [];
      for (var json in photoList) {
        PhotoModel photo = PhotoModel.fromJson(json);
        photoModelList.add(photo);
      }
      return photoModelList;
    }
    return [];
  }
}

class PhotoModel {
  final int id;
  final String imgUrl;

  PhotoModel(this.id, this.imgUrl);

  PhotoModel.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json['id']) ?? 0,
        imgUrl = json['imgUrl'];
}
