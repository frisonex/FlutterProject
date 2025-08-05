// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

const Color _customColor = Color.fromARGB(255, 68, 189, 84);

const List<Color> _colorThemes = [
  // Color.fromRGBO(128, 32, 179, 0.4),
  _customColor,
  Colors.orange,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < _colorThemes.length - 1,
  'Selected Color must be between 0 and ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        // primary: const Color.fromRGBO(58, 9, 84, 1),
        onSecondary: Colors.black12,
        onSurface: Colors.white,
        surface: Colors.transparent, //color for the surface of imput decorations
        error: Colors.red.shade500,
        onError: Colors.white,
      ),
    );
  }

  //Animación gradiente bordes
  LinearGradient animatedRadialGradient(AnimationController controller) {
    final topAligmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
              weight: 1
          ),
        ]
    ).animate(controller);

    final bottomAligmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
              weight: 1
          ),
        ]
    ).animate(controller);

    return LinearGradient(
        colors: [
          Color.fromRGBO(4, 116, 60, 1.0),
          Color.fromRGBO(54, 144, 99, 1.0),
          // Color.fromRGBO(3, 93, 48, 1.0),
          // Color.fromRGBO(205, 227, 216, 1.0),

        ],
        begin: topAligmentAnimation.value,
        end: bottomAligmentAnimation.value
    );
  }

  LinearGradient animatedRadialGradientSecondary(AnimationController controller) {
    final topAligmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
              weight: 1
          ),
        ]
    ).animate(controller);

    final bottomAligmentAnimation = TweenSequence<Alignment>(
        [
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
              weight: 1
          ),
          TweenSequenceItem(
              tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
              weight: 1
          ),
        ]
    ).animate(controller);

    return LinearGradient(
        colors: const[
          Color.fromARGB(255, 4, 4, 4),
          Color.fromARGB(207, 44, 44, 44),
        ],
        begin: topAligmentAnimation.value,
        end: bottomAligmentAnimation.value
    );
  }

}
