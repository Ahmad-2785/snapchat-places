import 'package:flutter/material.dart';

class Followings extends StatefulWidget {
  const Followings({super.key});

  @override
  State<Followings> createState() => _FollowingsState();
}

class _FollowingsState extends State<Followings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}
