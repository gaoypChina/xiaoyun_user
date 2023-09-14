import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';

class AppointmentTimeWidget extends StatefulWidget {
  final String startTime;
  final String endTime;
  final int earliestTime;
  final Function(String dateTimeStr, DateTime startDate)? confirmTimeCallback;

  const AppointmentTimeWidget(
      {super.key,
      this.confirmTimeCallback,
      required this.startTime,
      required this.endTime,
      required this.earliestTime});

  @override
  _AppointmentTimeWidgetState createState() => _AppointmentTimeWidgetState();
}

class _AppointmentTimeWidgetState extends State<AppointmentTimeWidget> {
  List<String> _dateList = [];
  List<DateTime> _dateTimeList = [];
  List<String> _timeList = [];
  FixedExtentScrollController _dateController = FixedExtentScrollController();
  FixedExtentScrollController _timeController = FixedExtentScrollController();
  DateTime _dateNow = DateTime.now();
  late bool _startToday;

  int _dateSelectedIndex = 0;
  int _timeSeletectedIndex = 0;

  @override
  void initState() {
    super.initState();

    int endTimeHour = int.tryParse(widget.endTime.split(":").first) ?? 18;
    int endTimeMinute = int.tryParse(widget.endTime.split(":").last) ?? 0;

    DateTime earliestDate = _dateNow.add(Duration(minutes: widget.earliestTime));
    DateTime endDate = DateTime(_dateNow.year, _dateNow.month, _dateNow.day,
        endTimeHour, endTimeMinute);
    Duration difference = endDate.difference(earliestDate);

    _startToday = difference.inHours > 0 ||
        (difference.inHours == 0 && difference.inMinutes > 30);

    _dateTimeList = List.generate(
      7,
      (index) => _dateNow.add(Duration(days: _startToday ? index : index + 1)),
    );
    for (var date in _dateTimeList) {
      _dateList.add(formatDate(date, [mm, "月", dd, "日"]));
    }
    _generateTimeList(isTaday: _startToday);
  }

  void _generateTimeList({bool isTaday = false}) {
    int startTimeHour = int.tryParse(widget.startTime.split(":").first) ?? 9;
    int startTimeMinute = int.tryParse(widget.startTime.split(":").last) ?? 0;
    int endTimeHour = int.tryParse(widget.endTime.split(":").first) ?? 18;
    int endTimeMinute = int.tryParse(widget.endTime.split(":").last) ?? 0;

    _timeList = [];
    if (isTaday) {
      DateTime earliestDate =
          _dateNow.add(Duration(minutes: widget.earliestTime));
      DateTime endDate = DateTime(_dateNow.year, _dateNow.month, _dateNow.day,
          endTimeHour, endTimeMinute);
      Duration difference = endDate.difference(earliestDate);
      DateTime tempEndDate = endDate;
      do {
        DateTime tempDate = tempEndDate.subtract(Duration(minutes: 30));
        String tempDateMinute = tempDate.minute == 0 ? "00" : "30";
        String tempEndDateMinute = tempEndDate.minute == 0 ? "00" : "30";
        String endHour = "${tempEndDate.hour}";
        if (tempEndDate.hour == 0) {
          endHour = "24";
        }
        _timeList.add(
            "${tempDate.hour}:$tempDateMinute-$endHour:$tempEndDateMinute");
        difference = tempDate.difference(earliestDate);
        tempEndDate = tempDate;
      } while (difference.inHours > 0 ||
          (difference.inHours == 0 && difference.inMinutes > 30));
      _timeList = _timeList.reversed.toList();
    } else {
      for (int i = startTimeHour; i < endTimeHour; i++) {
        if (startTimeMinute == 30) {
          _timeList.add("$i:30-${i + 1}:00");
        } else {
          _timeList.add("$i:00-$i:30");
          _timeList.add("$i:30-${i + 1}:00");
        }
      }
      if (endTimeMinute == 30) {
        _timeList.add("$endTimeHour:00 - $endTimeHour:30");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "预约时间段",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "可预约7日内${widget.startTime}-${widget.endTime}的服务，预约时间段不代表服务时长",
            style: TextStyle(
              color: DYColors.text_gray,
            ),
          ),
          SizedBox(height: 28),
          Divider(height: 0.5),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildListWheelScrollView(_dateList),
                ),
                Container(width: 1, height: 24, color: DYColors.divider),
                Expanded(
                  child: _buildListWheelScrollView(_timeList, isDate: false),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CommonActionButton(
                  title: "取消",
                  titleColor: DYColors.text_normal,
                  bgColor: Color(0xffDAE2E9),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: Constant.padding),
              Expanded(
                flex: 3,
                child: CommonActionButton(
                  title: "确定",
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.confirmTimeCallback != null) {
                      if (_timeList.isEmpty) return;
                      String dateStr = _dateList[_dateSelectedIndex];
                      String timeStr = _timeList[_timeSeletectedIndex];
                      String dateTimeStr = dateStr + " " + timeStr;

                      DateTime selectedDate = _dateTimeList[_dateSelectedIndex];
                      String startTime = timeStr.split("-").first;
                      int hour = int.parse(startTime.split(":").first);
                      int minute = int.parse(startTime.split(":").last);
                      DateTime startDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        hour,
                        minute,
                      );
                      widget.confirmTimeCallback?.call(dateTimeStr, startDate);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListWheelScrollView(List<String> valueList,
      {bool isDate = true}) {
    return ListWheelScrollView.useDelegate(
      controller: isDate ? _dateController : _timeController,
      itemExtent: 40,
      diameterRatio: 1.2,
      magnification: 1.6,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: valueList.length,
        builder: (context, index) {
          return Container(
            child: Center(
              child: Text(
                valueList[index],
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      onSelectedItemChanged: (value) {
        if (isDate) {
          if (value == 0 && _startToday) {
            _generateTimeList(isTaday: true);
          } else {
            _generateTimeList(isTaday: false);
          }
          _timeController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          _dateSelectedIndex = value;
          _timeSeletectedIndex = 0;
        } else {
          _timeSeletectedIndex = value;
        }
        setState(() {});
      },
    );
  }
}
