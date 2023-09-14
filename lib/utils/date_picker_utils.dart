import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';

class DatePickerUtils {
  static showDatePicker(
    BuildContext context, {
    DateTime? maxTime,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    ValueChanged<DateTime>? onConfirm,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return _DatePickerComponent(
          initialDateTime: initialDateTime,
          maxTime: maxTime,
          mode: mode,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

class _DatePickerComponent extends StatefulWidget {
  final ValueChanged<DateTime>? onConfirm;
  final DateTime? maxTime;
  final DateTime? initialDateTime;
  final CupertinoDatePickerMode mode;

  const _DatePickerComponent({
    this.onConfirm,
    this.maxTime,
    this.initialDateTime,
    required this.mode,
  });

  @override
  State<_DatePickerComponent> createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<_DatePickerComponent> {
  late DateTime _currentDateTime;
  late DateTime _initialDateTime;
  @override
  void initState() {
    _initialDateTime = widget.initialDateTime ?? DateTime.now();

    if (widget.maxTime != null) {
      if (widget.maxTime!.isBefore(_initialDateTime))
        _initialDateTime = widget.maxTime!;
    }
    _currentDateTime = _initialDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                minSize: 44,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              CupertinoButton(
                minSize: 44,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                onPressed: () {
                  widget.onConfirm?.call(_currentDateTime);
                  NavigatorUtils.goBack(context);
                },
                child: Text(
                  "确定",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 216,
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: Colors.white,
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              dateOrder: DatePickerDateOrder.ymd,
              mode: widget.mode,
              initialDateTime: _initialDateTime,
              maximumDate: widget.maxTime,
              onDateTimeChanged: (date) {
                _currentDateTime = date;
              },
            ),
          ),
        ),
      ],
    );
  }
}
