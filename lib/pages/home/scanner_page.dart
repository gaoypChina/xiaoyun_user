import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/photo_picker_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import '../../utils/navigator_utils.dart';
import '../../utils/toast_utils.dart';
import '../../widgets/common/navigation_item.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController _scannerController = MobileScannerController();
  AnimationController _controller;
  bool _flashOn = false;
  bool _hasDetected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _controller.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scannerWH = MediaQuery.of(context).size.width * 0.8;
    double lineHeight = 2;
    final offsetAnimation = Tween<Offset>(
            begin: Offset(0, -10),
            end: Offset(0, (scannerWH - lineHeight) / lineHeight + 10))
        .animate(_controller);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                SizedBox(height: 160),
                Container(
                  width: scannerWH,
                  height: scannerWH,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    // alignment: Alignment.center,
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (barcodes) => _hasDetected
                            ? null
                            : _detectAction(barcodes.barcodes.last),
                      ),
                      SlideTransition(
                        position: offsetAnimation,
                        child: Container(
                          height: lineHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff9F9F9F).withOpacity(0),
                                Color(0xffBFBFBF),
                                Color(0xffB7B7B7).withOpacity(0.14),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: DYLocalImage(
                          imageName: "home_scanner_tl",
                          size: 80,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: DYLocalImage(
                          imageName: "home_scanner_tr",
                          size: 80,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: DYLocalImage(
                          imageName: "home_scanner_bl",
                          size: 80,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: DYLocalImage(
                          imageName: "home_scanner_br",
                          size: 80,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "将二维码放入框内，即可自动扫描",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: 70,
                      height: 70,
                      child: IconButton(
                        icon: Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white,
                        ),
                        iconSize: 32,
                        onPressed: () async {
                          File image = await PhotoPickerUtils.pickPhoto(context,
                              galleryOnly: true);
                          if (image != null) {
                            bool result = await _scannerController
                                .analyzeImage(image.path);
                            if (!result) {
                              DialogUtils.showAlertDialog(
                                context,
                                message: "没有识别到二维码，请重新选择",
                                confirmAction: () {},
                              );
                            }
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  NavigationItem(
                    iconName: "navigation_back_white",
                    iconSize: 24,
                    onPressed: () {
                      NavigatorUtils.goBack(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "扫一扫",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      this._flashOn ? Icons.flash_off : Icons.flash_on,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleFlash() {
    _scannerController.toggleTorch();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  void _detectAction(Barcode barcode) {
    if (_scannerController.isStarting) {
      _scannerController.stop();
    }
    if (barcode.rawValue == null) {
      debugPrint('Failed to scan Barcode');
      NavigatorUtils.goBack(context);
      ToastUtils.showError("识别失败！");
    } else {
      _hasDetected = true;
      final String code = barcode.rawValue;
      debugPrint('Barcode found! $code');
      Future.delayed(Duration(seconds: 1)).then((value) {
        if (!mounted) return;
        NavigatorUtils.goBackWithParams(context, code);
        print("scanData ------- $code");
      });
    }
  }
}
