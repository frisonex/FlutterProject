import 'package:flutter/material.dart';

class CustomEventCard extends StatelessWidget {
  final double heightFactor;
  final double widthFactor;
  final double paddingFactor;
  final String title;
  final String? description;
  final String? buttonText;
  final VoidCallback onPressed;
  final Widget icon;

  const CustomEventCard({super.key, this.heightFactor = 0.4, this.widthFactor = 0.2, this.paddingFactor = 0.02, required this.title, this.description, this.buttonText, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * heightFactor,
      width: size.width * widthFactor,
      padding: EdgeInsets.symmetric(horizontal: size.width * paddingFactor, vertical: size.height * 0.075),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: size.height * 0.024, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: Center(
              child: SizedBox(
                height: size.height * 0.10,
                width:  size.height * 0.10,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: icon,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: const Color.fromRGBO(54, 182, 13, 1.0), borderRadius: BorderRadius.circular(size.width * 0.008)),
              child: Center(
                child: Text(
                  buttonText!,
                  style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: size.height * 0.020, color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
