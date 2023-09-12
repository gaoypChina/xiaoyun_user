import 'package:flutter/cupertino.dart';
import 'package:xiaoyun_user/constant/constant.dart';

enum HomeMenuType { now, appointment }

class HomeMenuBtn extends StatelessWidget {
  final HomeMenuType menuType;
  final Function(HomeMenuType menuType) menuBtnClicked;

  const HomeMenuBtn({
    Key key,
    this.menuBtnClicked,
    this.menuType = HomeMenuType.now,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          MenuBtnItem(
            title: "现在",
            isChecked: menuType == HomeMenuType.now,
            onPressed: () {
              this.menuBtnClicked(HomeMenuType.now);
            },
          ),
          SizedBox(width: 32),
          MenuBtnItem(
            title: "预约",
            isChecked: menuType == HomeMenuType.appointment,
            onPressed: () {
              this.menuBtnClicked(HomeMenuType.appointment);
            },
          ),
        ],
      ),
    );
  }
}

class MenuBtnItem extends StatelessWidget {
  final String title;
  final bool isChecked;
  final Function onPressed;

  const MenuBtnItem(
      {Key key, this.title, this.isChecked = true, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (isChecked)
            Container(
              width: 32,
              height: 8,
              color: DYColors.primary,
            ),
          Text(
            title,
            style: TextStyle(
              color: isChecked
                  ? DYColors.text_normal
                  : DYColors.text_normal.withOpacity(0.8),
            ),
          ),
        ],
      ),
      onPressed: this.onPressed,
    );
  }
}
