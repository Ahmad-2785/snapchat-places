import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onpressed,
    required this.text,
    required this.color
  });

  final onpressed;
  final String text;
  final Color color;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFECEEEF)),
          borderRadius: BorderRadius.circular(48),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: -4,
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(48),
        child: ElevatedButton(
          onPressed: () {
            widget.onpressed;
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xFF6155A6))),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.color,
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
