import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color mainColor;
  final String? errorText;
  final Function(String)? onChanged;
  final bool? obscureText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color? selectionColor;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.mainColor,
    this.errorText,
    this.onChanged,
    this.obscureText,
    this.focusNode,
    this.onFieldSubmitted,
    this.autofocus,
    this.inputFormatters,
    this.validator,
    this.selectionColor,
    this.readOnly,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final bool _isFocused = false;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    // _errorText = widget.errorText;
    _isObscure = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final primaryColor = widget.mainColor;
    final secondaryColor = widget.mainColor;
    const backgroundColor = Colors.transparent;
    final hintTextColor = widget.mainColor;

    final borderRadius = screenWidth * 0.008;
    final borderWidth = screenWidth * 0.0007;
    final paddingVertical = screenHeight * 0.02;
    final paddingHorizontal = screenWidth * 0.0125;

    return Theme(
      data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.grey,
          )),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscure,
        focusNode: widget.focusNode,
        onSubmitted: widget.onFieldSubmitted,
        autofocus: widget.autofocus ?? false,
        readOnly: widget.readOnly ?? false,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(
          fontSize: mediaQuery.size.height * 0.022,
          color: secondaryColor,
          fontFamily: 'Poppins',
        ),
        cursorColor: primaryColor,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _isFocused ? primaryColor : hintTextColor,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: mediaQuery.size.height * 0.022,
            color: hintTextColor,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.italic,
          ),
          filled: true,
          fillColor: backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: hintTextColor, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: primaryColor, width: borderWidth * 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red, width: borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red, width: borderWidth * 3),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          errorText: widget.errorText,
          errorMaxLines: 4,
          errorStyle: TextStyle(
            color: Colors.red,
            fontFamily: 'Poppins',
            fontSize: mediaQuery.size.height * 0.022,
          ),
          suffixIcon: widget.obscureText == true
              ? IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: hintTextColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )
              : null,
        ),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }

          if (widget.validator != null) {
            setState(() {
              widget.validator!(value);
            });
          }
        },
      ),
    );
  }
}
