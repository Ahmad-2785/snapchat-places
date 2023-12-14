import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:snapchat/src/res/routes/routes.dart';
import 'package:snapchat/src/view/signin/components/signin_options.dart';

import 'privacy_policy_link.dart';
// import 'package:snapchat/src/auth/signin_with_google.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  set receivedID(String receivedID) {}
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    const initialCountryCode = 'US';
    var country =
        countries.firstWhere((element) => element.code == initialCountryCode);
    var isValid = false;

    FirebaseAuth auth = FirebaseAuth.instance;
    // TextEditingController otpController = TextEditingController();
    String phoneNumber = '';
    int? resendtoken;

    Future<void> getOtp({required String phoneNumber}) async {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {
            setState(() {
              isLoading = false;
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (verificationID, int? resendtoken) async {
            resendtoken = resendtoken;

            Map<String, dynamic> data = {
              'receivedID': verificationID,
              'resendToken': resendtoken,
              'phoneNumber': phoneNumber
            };
            setState(() {
              isLoading = false;
            });
            Get.toNamed(Routes.otpScreen, arguments: data);
          },
          forceResendingToken: resendtoken,
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: (verificationID) async {
            setState(() {
              isLoading = false;
            });
          });
      // setState(() {
      //   isLoading = false;
      // });
    }

    void submit() {
      if (isValid) {
        setState(() {
          isLoading = true;
        });
        getOtp(phoneNumber: phoneNumber);
      } else {}
    }

    // Future<void> verifyOTPCode() async {
    //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //     verificationId: receivedID,
    //     smsCode: otpController.text,
    //   );
    //   await auth
    //       .signInWithCredential(credential)
    //       .then((value) => print('User Login In Successful'));
    // }

    return Stack(
      children: [
        SingleChildScrollView(
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
                    const Text(
                      'Enter your phone number',
                      style: TextStyle(
                        color: Color(0xFF0F1D27),
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const SizedBox(
                      width: 335,
                      height: 19,
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Color(0xFF3D4850),
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    IntlPhoneField(
                      disableLengthCheck: false,
                      showCursor: false,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      flagsButtonMargin: const EdgeInsets.only(right: 0),
                      flagsButtonPadding: const EdgeInsets.only(left: 16),
                      dropdownIcon: const Icon(
                        IconData(0xe353, fontFamily: 'MaterialIcons'),
                        color: Color(0xFFA7ACAF),
                      ),
                      dropdownIconPosition: IconPosition.trailing,
                      decoration: InputDecoration(
                        prefix: Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 3.0)
                            ..rotateZ(-1.57),
                          child: Container(
                            width: 16,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFFA7ACAF),
                                ),
                              ),
                            ),
                          ),
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFA7ACAF),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F9F9),
                        hintText: "Phone Number",
                        labelText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      initialCountryCode: 'US',
                      onCountryChanged: (country) => country = country,
                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                        if (phone.number.length >= country.minLength &&
                            phone.number.length <= country.maxLength) {
                          isValid = true;
                        } else {
                          isValid = false;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: ShapeDecoration(
                        color: const Color.fromARGB(255, 41, 3, 255),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFECEEEF)),
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
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFF6155A6))),
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
                          'Or log in with',
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
        ),
        isLoading
            ? Positioned.fill(
                child: Container(
                  color: const Color(0xFF8B9296).withOpacity(0.8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      width: 100,
                      height: 100,
                      decoration: ShapeDecoration(
                        // color: Color.fromARGB(255, 41, 3, 255).withOpacity(0.2),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
