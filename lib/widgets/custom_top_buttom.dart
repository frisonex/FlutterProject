import 'package:flutter/material.dart';

class CustomTopButton extends StatelessWidget {
  final double? topOffset;
  final double? leftOffset;
  final IconData icon;
  final String? text;
  final Color? iconColor;
  final bool? positionRight;

  final Function onPressed;

  const CustomTopButton({
    super.key,
    this.topOffset,
    this.leftOffset,
    required this.icon,
    required this.onPressed,
    this.text,
    this.iconColor,
    this.positionRight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      right: positionRight == true ? size.width * 0.02 : null,
      left: positionRight == false ? size.width * 0.02 : null,
      top: size.height * 0.066,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.8),
          color: Colors.transparent,
        ),
        child: InkWell(
          onTap: () async {
            await onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              SizedBox(width: size.width * 0.004),
              Text(
                text ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.01,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: size.width * 0.004),
            ],
          ),
        ),
      ),
    );
  }
}
