import 'package:url_launcher/url_launcher.dart';
import 'toast_utils.dart';
// import 'package:keyboard_actions/keyboard_actions.dart';

class CommonUtils {
  static String getImagePath(String name, String path, {String format = 'png'}) {
    return 'assets/images/$path/$name.$format';
  }

  static void launchTelUrl(String phone) async {
    String urlStr = 'tel:' + phone;
    Uri? url = Uri.tryParse(urlStr);
    if (await canLaunchUrl(url!)) {
      await launchUrl(url);
    } else {
      ToastUtils.showError('拨号失败！');
    }
    // if (await canLaunch(urlStr)) {
    //   await launch(urlStr);
    // } else {
    //   ToastUtils.showError('拨号失败！');
    // }
  }

  static void launchWebUrl(String urlStr) async {
    Uri? url = Uri.tryParse(urlStr);
    if (await canLaunchUrl(url!)) {
      await launchUrl(url);
    } else {
      ToastUtils.showError('链接无效，打开失败');
    }
  }

  // static KeyboardActionsConfig getKeyboardActionsConfig(List<FocusNode> list) {
  //   return KeyboardActionsConfig(
  //     keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
  //     keyboardBarColor: Colors.grey[200],
  //     nextFocus: true,
  //     actions: List.generate(
  //       list.length,
  //       (i) => KeyboardAction(
  //         focusNode: list[i],
  //         closeWidget: const Padding(
  //           padding: const EdgeInsets.all(5.0),
  //           child: Text('关闭'),
  //         ),
  //       ),
  //     ),
  //   // );
  // }
}
