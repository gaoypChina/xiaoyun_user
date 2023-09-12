import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _flashOn = false;
  QRViewController _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    } else if (Platform.isIOS) {
      _controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 30,
              borderLength: 60,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 360),
              child: Text(
                "将二维码放入框内，即可自动扫描",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
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
    _controller.toggleFlash();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      NavigatorUtils.goBackWithParams(context, scanData.code);
      print("scanData ------- ${scanData.code}");
    });
  }
}
