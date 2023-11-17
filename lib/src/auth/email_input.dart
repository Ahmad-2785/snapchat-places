import 'package:flutter/material.dart';

class ImailInput extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;

  const ImailInput({
    super.key,
    required this.labelText,
    required this.icon,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<ImailInput> createState() => _ImailInputState();
}

class _ImailInputState extends State<ImailInput> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 71,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 19,
            child: Text(
              widget.labelText,
              style: const TextStyle(
                color: Color(0xFF3D4850),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: const Color(0xFFF8F9F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 24,
                  color: const Color(0xFFA7ACAF),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  height: 16,
                  child: VerticalDivider(
                    width: 16,
                    thickness: 1,
                    color: Color(0xFFA7ACAF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: widget.onChanged,
                    style: const TextStyle(
                      color: Color(0xFF3D4850),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        color: Color(0xFF9C9C9C),
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
