import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 88,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.arrow_left_sharp,
                        size: 24,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Complete profile',
                        style: TextStyle(
                          color: Color(0xFF0F1D27),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.arrow_left_sharp,
                        size: 24,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 76,
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                        child: Image.asset(
                      'assets/images/logo_white.png',
                      width: 75,
                      height: 75,
                    )),
                  ),
                  const SizedBox(
                    width: 16,
                    height: 76,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Club carbie',
                        style: TextStyle(
                          color: Color(0xFF0F1D27),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Closed today',
                            style: TextStyle(
                              color: Color(0xFFFD363B),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFECEEEF),
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'San Jose, CA',
                            style: TextStyle(
                              color: Color(0xFFA7ACAF),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Container(
              height: 48,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '362',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0F1D27),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
