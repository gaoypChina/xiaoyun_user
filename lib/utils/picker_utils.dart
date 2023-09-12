import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';

class PickerUtils {
  static int _selectedIndex = 0;

  static Future showPicker(BuildContext context, List<String> titleList,
      {int index = 0, Function(int selectedIndex) confirmCallback}) async {
    final double _kPickerSheetHeight = 216.0;
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: index);
    _selectedIndex = index;

    int selectedIndex = await showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 40,
              color: Color(0xffeeeeee),
              child: Row(
                children: <Widget>[
                  CupertinoButton(
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                    minSize: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    onPressed: () {
                      Navigator.pop(context, -1);
                    },
                  ),
                  Expanded(child: Container()),
                  CupertinoButton(
                    child: Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 14,
                        color: DYColors.primary,
                      ),
                    ),
                    minSize: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    onPressed: () {
                      Navigator.pop(context, _selectedIndex);
                    },
                  )
                ],
              ),
            ),
            Container(
              height: _kPickerSheetHeight,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 36,
                magnification: 1.0,
                scrollController: scrollController,
                children: List<Widget>.generate(titleList.length, (int index) {
                  return Center(
                    child: Text(
                      titleList[index],
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff333333),
                      ),
                    ),
                  );
                }),
                onSelectedItemChanged: (int index) {
                  _selectedIndex = index;
                },
              ),
            ),
          ],
        );
      },
    );
    if (selectedIndex != null && selectedIndex != -1) {
      confirmCallback(selectedIndex);
    }
  }
}
