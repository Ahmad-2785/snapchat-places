import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat/src/res/routes/routes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _username = "";
  bool nightmode = true;
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("USERNAME");
    setState(() {
      _username = username ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9F9),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 88,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 44,
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Settings',
                          style: TextStyle(
                            color: Color(0xFF0F1D27),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'My account',
                      style: TextStyle(
                        color: Color(0xFF6155A6),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Color(0xFFECEEEF)),
                        top: BorderSide(color: Color(0xFFECEEEF)),
                        right: BorderSide(color: Color(0xFFECEEEF)),
                        bottom: BorderSide(width: 1, color: Color(0xFFECEEEF)),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User name',
                          style: TextStyle(
                            color: Color(0xFF0F1D27),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Text(
                          _username,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFFA7ACAF),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'More',
                      style: TextStyle(
                        color: Color(0xFF6155A6),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Color(0xFFECEEEF)),
                        top: BorderSide(color: Color(0xFFECEEEF)),
                        right: BorderSide(color: Color(0xFFECEEEF)),
                        bottom: BorderSide(width: 1, color: Color(0xFFECEEEF)),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    height: 76,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Night mode',
                          style: TextStyle(
                            color: Color(0xFF0F1D27),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Switch(
                            inactiveTrackColor: const Color(0xFFC5C9CC),
                            value: nightmode,
                            onChanged: (bool value) {
                              setState(() {
                                nightmode = value;
                              });
                            })
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.termsAndConditions);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFFECEEEF)),
                          top: BorderSide(color: Color(0xFFECEEEF)),
                          right: BorderSide(color: Color(0xFFECEEEF)),
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFECEEEF)),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      height: 76,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms and conditions',
                            style: TextStyle(
                              color: Color(0xFF0F1D27),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.privacyAndPolicy);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Color(0xFFECEEEF)),
                          top: BorderSide(color: Color(0xFFECEEEF)),
                          right: BorderSide(color: Color(0xFFECEEEF)),
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFECEEEF)),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      height: 76,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy and policy',
                            style: TextStyle(
                              color: Color(0xFF0F1D27),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
