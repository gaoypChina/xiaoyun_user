import 'dart:async';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../utils/toast_utils.dart';

class GetCodeBtn extends StatefulWidget {
  final TextEditingController? phoneController;
  final String title;
  final Function(VoidCallback resetTimer) onClicked;
  final double width;
  final String? phoneNo;
  final bool startOnBuild;

  const GetCodeBtn({
    super.key,
    required this.onClicked,
    this.width = 90,
    this.title = "获取验证码",
    this.phoneController,
    this.phoneNo,
    this.startOnBuild = false,
  });

  @override
  _GetCodeBtnState createState() => _GetCodeBtnState();
}

class _GetCodeBtnState extends State<GetCodeBtn> {
  Timer? _timer;
  int _countdownTime = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startOnBuild) {
      _countdownTime = 60;
      _startCountdownTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        child: Text(
          _countdownTime > 0 ? '$_countdownTime秒重发' : '获取验证码',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: _countdownTime > 0 ? Colors.black38 : DYColors.primary,
          ),
        ),
        onTap: () {
          String phoneNo = widget.phoneNo ?? widget.phoneController?.text??'';
          if (phoneNo.isEmpty) {
            ToastUtils.showInfo("无法获取到手机号");
            return;
          }
          if (phoneNo.length != 11) {
            ToastUtils.showInfo('请输入11位有效的手机号');
            return;
          }
          if (_countdownTime == 0) {
            setState(() {
              _countdownTime = 60;
            });
            _startCountdownTimer();
            widget.onClicked(_resetTimer);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _countdownTime = 0;
      if (_timer != null) {
        _timer!.cancel();
      }
    });
  }

  void _startCountdownTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    const oneSec = const Duration(seconds: 1);
    var callback = (_timer) => {
      setState(
            () {
          if (_countdownTime < 1) {
            _timer.cancel();
          } else {
            _countdownTime = _countdownTime - 1;
          }
        },
      )
    };
    _timer = Timer.periodic(oneSec, callback);
  }
}
