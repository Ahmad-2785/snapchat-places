import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Setting"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Second"),
        ),
      ],
      offset: Offset(0, 40),
      onSelected: (value) {
        print("value:$value");
      },
      child: Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.black.withOpacity(0.23999999463558197),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
        child: Center(
          child: Container(
              width: 20,
              height: 20,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Icon(
                Icons.settings_outlined,
                size: 20,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
