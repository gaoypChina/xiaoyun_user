import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    if (hexColor.isEmpty) {
      hexColor = '#FFC0C3E7';
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}