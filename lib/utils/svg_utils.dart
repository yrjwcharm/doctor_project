
import 'package:flutter_svg/svg.dart';
class SvgUtil {
  static String svgPath(String svgName) {
    return "assets/svg/$svgName";
  }

  static SvgPicture svg(String svgName, {double width, double height}) {
    var name = svgName;
    if (name.endsWith(".svg") == false) {
      name = "$svgName.svg";
    }
    return SvgPicture.asset(SvgUtil.svgPath(name), width: width, height: height,);
  }
}