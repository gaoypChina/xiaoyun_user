import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class CarProvinceWidget extends StatelessWidget {
  final Function(String value)? onClicked;

  const CarProvinceWidget({super.key, this.onClicked});

  @override
  Widget build(BuildContext context) {
    final String provinces = "京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川贵云藏陕甘青宁新";
    return GridView(
      children: provinces.characters
          .map(
            (e) => GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text(e),
                decoration: BoxDecoration(
                  border: Border.all(color: DYColors.divider, width: 1),
                ),
              ),
              onTap: () {
                this.onClicked?.call(e);
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 0.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
