import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';

import '../routes/route_export.dart';
import '../utils/navigator_utils.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          PageView(
            children: [0, 1, 2].map((index) => _buildBody(index)).toList(),
            controller: _pageController,
            onPageChanged: (index) {
              if (index == _currentIndex) return;
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            right: 10,
            child: SafeArea(
              child: CupertinoButton(
                child: Text(
                  "跳过",
                  style: TextStyle(color: DYColors.text_gray),
                ),
                onPressed: () {
                  NavigatorUtils.push(context, Routes.main,
                      replace: true, clearStack: true);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(int index) {
    String assetName = "assets/images/common/welcome_$index.png";
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetName),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: index == 2 ? 30 : 45,
          child: SafeArea(
            child: index == 2
                ? CommonActionButton(
                    title: "立即开启",
                    width: 200,
                    onPressed: () {
                      NavigatorUtils.push(context, Routes.main,
                          replace: true, clearStack: true);
                    },
                  )
                : AnimatedSmoothIndicator(
                    activeIndex: index,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: DYColors.primary,
                      dotColor: DYColors.primary.withOpacity(0.36),
                      expansionFactor: 1.1,
                      dotWidth: 8,
                      dotHeight: 8,
                      spacing: 20,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
