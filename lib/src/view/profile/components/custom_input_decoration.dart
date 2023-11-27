import 'package:flutter/material.dart';

InputDecoration CustomInputDecoration(String hintText, Icon prefixIcon,
    {fillColor = 0xFFF8F9F9}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(14),
    prefix: Transform(
      transform: Matrix4.identity()
        ..translate(0.0, 3.0)
        ..rotateZ(-1.57),
      child: Container(
        width: 16,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFFA7ACAF),
            ),
          ),
        ),
      ),
    ),
    hintText: hintText,
    errorStyle: TextStyle(color: Color(0xFFFD363B)),
    prefixIcon: prefixIcon,
    hintStyle: const TextStyle(
      color: Color(0xFFA7ACAF),
      fontSize: 16,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w400,
      height: 0,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(50),
    ),
    filled: true,
    fillColor: fillColor,
  );
}
