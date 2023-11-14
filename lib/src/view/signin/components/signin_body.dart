import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:snapchat/src/res/app_color.dart';
import 'package:snapchat/src/view/signin/components/signin_options.dart';

import 'privacy_policy_link.dart';
// import 'package:snapchat/src/auth/signin_with_google.dart';

class SignInBody extends StatelessWidget {
  const SignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    const initialCountryCode = 'US';
    var country =
        countries.firstWhere((element) => element.code == initialCountryCode);
    var isValid = false;
    void submit(){
      print(isValid);
    }
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo_pink.png',
                  width: 66,
                  height: 82,
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                IntlPhoneField(
                  autofocus: true,
                  flagsButtonPadding: const EdgeInsets.all(8),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  initialCountryCode: 'US',
                  onCountryChanged: (country) => country = country,
                  onChanged: (phone) {
                    if (phone.number.length >= country.minLength &&
                        phone.number.length <= country.maxLength) {
                        isValid = true;
                    }else{
                      isValid = false;
                    }
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFECEEEF)),
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
                        submit();
                      },
                      child: const Text(
                        'Log in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Color(0xFFEDEFF0),
                      thickness: 2,
                    )),
                    Text(
                      'Or sign up with',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA7ACAF),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                      color: Color(0xFFEDEFF0),
                    )),
                    SizedBox(height: 16),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SignInOptions(),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            const PrivacyPolicyLink(),
          ],
        ),
      ),
    );
  }
}
