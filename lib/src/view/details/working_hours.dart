import 'package:flutter/material.dart';

class WorkingHours extends StatelessWidget {
  const WorkingHours({super.key, required this.weekdayDescriptions});
  final List<dynamic> weekdayDescriptions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFECEEEF)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            //Monday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[0].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[0].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Tuesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tuesday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[1].substring(9)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[1].substring(9) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Wednesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wednesday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[2].substring(11)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[2].substring(11) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Thursday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thursday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[3].substring(10)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[3].substring(10) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Friday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Friday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[4].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[4].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Saturday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saturday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[5].substring(10)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[5].substring(10) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFECEEEF), thickness: 1),
            //Sunday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sunday',
                    style: TextStyle(
                      color: Color(0xFF70787E),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                  Text(
                    weekdayDescriptions.isNotEmpty
                        ? weekdayDescriptions[6].substring(8)
                        : "",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: weekdayDescriptions.isNotEmpty &&
                              weekdayDescriptions[6].substring(8) == "Closed"
                          ? const Color(0xFFFD363B)
                          : const Color(0xFF0F1D27),
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ],
    );
  }
}
