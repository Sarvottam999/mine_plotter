import 'package:flutter/material.dart';

class NIconButton extends StatelessWidget {
  // final String? svgPath;
  final Widget? icon;
    final String? text;

  final VoidCallback onPressed;
  final Color backgroundColor;
  // final Color? iconColor;
    final Color? textColor;

  final double size;
    final double? fontSize;

  // final double iconSize;
  final double borderRadius;

  const NIconButton({
    Key? key,
    this.text,
    this.icon,
    this.textColor, 
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.fontSize,
    this.size = 35,
    // this.iconSize = 24,
    this.borderRadius = 8.0,
  });
      

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      // width: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: icon != null && text != null 
                  ? MainAxisAlignment.start 
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) 
                  icon!,
                if (icon != null && text != null) 
                  const SizedBox(width: 8),
                if (text != null)
                  Text(
                    text!,
                    style: TextStyle(
                      color: textColor ?? Colors.black,
                      fontSize: fontSize ?? 14,
                      // fontWeight: fontWeight ?? FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        ),
      
     
    );
  }
}