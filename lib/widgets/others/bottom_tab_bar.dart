import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomTabBarItem> tabBarItems;

  const BottomTabBar({Key key, this.currentIndex, this.onTap, this.tabBarItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: tabBarItems,
        selectedItemColor: DYColors.primary,
        unselectedItemColor: DYColors.text_gray,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        unselectedFontSize: 10,
        selectedFontSize: 11,
        onTap: onTap,
      ),
    );
  }
}

class BottomTabBarItem extends BottomNavigationBarItem {
  final String iconName;
  final String activeIconName;
  final String name;

  BottomTabBarItem({
    this.iconName,
    this.activeIconName,
    this.name,
  }) : super(
          icon: DYLocalImage(
            imageName: iconName,
            path: "tabbar",
            size: 24,
          ),
          activeIcon: DYLocalImage(
            imageName: activeIconName,
            path: "tabbar",
            size: 24,
          ),
          label: name,
        );
}
