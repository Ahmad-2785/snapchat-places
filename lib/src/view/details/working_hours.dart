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
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.onSecondary),
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
                  Text(
                    'Monday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Tuesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tuesday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Wednesday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wednesday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Thursday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thursday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  )
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Friday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Friday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Saturday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saturday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.onSecondary, thickness: 1),
            //Sunday
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sunday',
                    style: Theme.of(context).textTheme.displaySmall,
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
                          : Theme.of(context).colorScheme.tertiaryContainer,
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
