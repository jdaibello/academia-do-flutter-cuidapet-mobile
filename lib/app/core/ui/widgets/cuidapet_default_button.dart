import 'package:cuidapet_mobile/app/core/ui/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class CuidapetDefaultButton extends StatelessWidget {
  final String label;
  final double width;
  final double heigth;
  final double padding;
  final Color? color;
  final Color? labelColor;
  final double borderRadius;

  const CuidapetDefaultButton({
    required this.label,
    this.heigth = 66,
    this.width = double.infinity,
    this.padding = 10,
    this.color,
    this.borderRadius = 10,
    this.labelColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: width,
      height: heigth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          primary: color ?? context.primaryColor,
        ),
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: labelColor,
          ),
        ),
      ),
    );
  }
}
