import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/util/utils.dart';
import 'package:snapchat/src/view/profile/complete_profile.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../res/routes/routes.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  final CountdownController _timeController =
      CountdownController(autoStart: true);

  var isError = false;
  var resned2 = true;
  int? newResendToken;
  String newreceivedID = "";
  String phoneNumber = "";
  final Map<String, dynamic> data = Get.arguments;

  String formatTime(double seconds) {
    int flooredSeconds = seconds.floor();
    int minutes = (flooredSeconds / 60).floor();
    int remainingSeconds = flooredSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    newResendToken = data['resendToken'];
    newreceivedID = data['receivedID'];
    phoneNumber = data['phoneNumber'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo image
            Image.asset(
              'assets/images/logo_pink.png',
              width: 66,
              height: 82,
            ),
            const SizedBox(
              height: 24,
            ),

            // Page Title
            const Text(
              'Verify',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700),
            ),
            const Text(
              "Please enter 6-digit code we've sent to",
              style: TextStyle(
                color: Color(0xFF0F1D27),
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),

            // Help Text
            Text(
              "${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 8)} ${phoneNumber.substring(8, 11)}",
              style: const TextStyle(
                color: Color(0xFF6155A6),
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            const SizedBox(height: 24),

            // Verification Code Textfield
            SizedBox(
              height: 48,
              child: OtpTextField(
                onSubmit: (value) {
                  otpController.text = value;
                },
                clearText: !isError,
                showCursor: false,
                numberOfFields: 6,
                fieldWidth: 48,
                filled: true,
                fillColor: const Color(0xFFF8F9F9),
                borderColor:
                    isError ? const Color(0xFFFD363B) : const Color(0xFFF8F9F9),
                enabledBorderColor:
                    isError ? const Color(0xFFFD363B) : const Color(0xFFF8F9F9),
                focusedBorderColor:
                    isError ? const Color(0xFFFD363B) : const Color(0xFFF8F9F9),
                borderWidth: 1,
                textStyle: TextStyle(
                  color: isError
                      ? const Color(0xFFFD363B)
                      : const Color(0xFF6155A6),
                ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                showFieldAsBox: true,
                borderRadius: const BorderRadius.all(Radius.circular(48.0)),
              ),
            ),
            const SizedBox(height: 24),

            // Verify Button
            Container(
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFECEEEF)),
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
                    AuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: newreceivedID,
                            smsCode: otpController.text);
                    signin(phoneAuthCredential);
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF6155A6))),
                  child: const Text(
                    'Verify',
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
            const SizedBox(height: 16),

            // Resend Verification Button
            Builder(builder: (context) {
              if (resned2) {
                return Opacity(
                  opacity: 0.48,
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFEFEEF6)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFEFEEF6))),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Resend in: ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            Countdown(
                              controller: _timeController,
                              seconds: 120,
                              build: (_, double time) => Text(
                                formatTime(time),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              interval: const Duration(milliseconds: 1000),
                              onFinished: () {
                                setState(() {
                                  resned2 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFEFEEF6)),
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  height: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFEFEEF6))),
                      onPressed: () {
                        resendOTP(phoneNumber: phoneNumber);
                      },
                      child: Text(
                        'Resend',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  void signin(AuthCredential phoneAuthCredential) async {
    try {
      final authCred =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        print("signin success");
        Get.offAll(() => const CompleteProfile());
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      Utils.showSnackBar(
          const Text(
            'Invalid code',
            style: TextStyle(
              color: Color(0xFF0F1D27),
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          const Text(
            'Verification code is invalid, please try again',
            style: TextStyle(
              color: Color(0xFF566067),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const Icon(
            IconData(0xe237, fontFamily: 'MaterialIcons'),
            color: Color(0xFFFD363B),
            size: 20,
          ),
          color: const Color(0xFFFFEBEB),
          borderColor: const Color(0xFFFD363B));
      setState(() {
        isError = true;
        resned2 = false;
      });
    }
  }

  Future<void> resendOTP({required String phoneNumber}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {});
        },
        codeSent: (verificationID, resendingToken) async {
          _timeController.restart();
          Utils.showSnackBar(
              const Text(
                'Code sent',
                style: TextStyle(
                  color: Color(0xFF0F1D27),
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const Text(
                'Verification code has been resent',
                style: TextStyle(
                  color: Color(0xFF566067),
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const Icon(
                IconData(0xe237, fontFamily: 'MaterialIcons'),
                color: Color(0xFF6155A6),
                size: 20,
              ),
              color: const Color(0xFFEFEEF6),
              borderColor: const Color(0xFF6155A6));
          setState(() {
            newreceivedID = verificationID;
            newResendToken = resendingToken;
            resned2 = true;
            isError = false;
          });
        },
        forceResendingToken: newResendToken,
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (verificationID) async {});
  }
}
