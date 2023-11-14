import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class PrivacyPolicyLink extends StatelessWidget {
  const PrivacyPolicyLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          const Text(
            'By signing up, you agree with',
            style: TextStyle(
              color: Color(0xFF70787E),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          RichText(
            text: TextSpan(
              text: 'Term of service',
              style: const TextStyle(
                color: Color(0xFF6155A6),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("term of service");
                },
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            'and',
            style: TextStyle(
              color: Color(0xFF70787E),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Privacy policy',
              style: const TextStyle(
                color: Color(0xFF6155A6),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("privacy policy");
                },
            ),
          ),
        ],
      ),
    );
  }
}
