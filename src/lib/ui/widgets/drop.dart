import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';

class Drop extends StatelessWidget {

  final Widget? image;
  final double width;
  final double height;
  final bool? reversed;
  final Color? color;

  const Drop({Key? key, this.image, required this.width, required this.height, this.reversed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: reversed ?? false ? -1.0 : 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: width, height: height, decoration: BoxDecoration(boxShadow: kElevationToShadow[2],border: Border.all(color: color != null ? color! : ColorSchemes.kingacolorAccent.withRed(0), width: 3.0),color: ColorSchemes.kingacolor.shade50, borderRadius: const BorderRadiusDirectional.only(topStart: Radius.circular(500), topEnd: Radius.circular(500), bottomStart: Radius.circular(500), bottomEnd: Radius.circular(80))),),
          image != null ? Container(padding: EdgeInsets.only(left: width * 0.05), width: width * 0.7, height: height * 0.7, child: Transform.scale(
            scaleX: reversed ?? false ? -1.0 : 1.0,
            child: image,
          )) : Container(),
        ],
      ),
    );
  }
}
