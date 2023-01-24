import 'package:flutter/material.dart';

class BorderBox extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final EdgeInsets? padding;
  final Color color;
  final bool margin;

  const BorderBox(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.padding,
      required this.color,
      required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: padding ?? const EdgeInsets.all(8.0),
      margin: margin ? const EdgeInsets.only(right: 5) : null,
      child: Center(child: child),
    );
  }
}
