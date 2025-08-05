import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  final BoxDecoration decoration;
  final Widget child;
  final double? width;
  final BorderRadius? borderRadius;

  const CustomAnimatedContainer({
    super.key,
    required this.decoration,
    required this.child,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: size.height * 0.06,
      width: width ?? size.width * 0.083,
      decoration: decoration,
      child: child,
    );
  }
}
