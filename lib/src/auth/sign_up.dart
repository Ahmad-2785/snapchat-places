import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:snapchat/src/auth/sign_in.dart';
import 'package:snapchat/src/auth/email_input.dart';
import 'package:snapchat/src/auth/signin_with_google.dart';
import 'package:snapchat/src/auth/signup_form.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SingUpPage> {
  static const IconData apple = IconData(0xf04be, fontFamily: 'MaterialIcons');
  static const IconData emailOutlined =
      IconData(0xf018, fontFamily: 'MaterialIcons');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';

  void _signupWithEmail() {
    if (_formKey.currentState!.validate()) {
      print("validate email");
    } else {
      print("incorrect email");
    }
  }

  void setEmail(String value) {
    setState(() {
      print(value);
      email = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: SingleChildScrollView(
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
                    'Sign up',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF0F1D27),
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: Color(0xFF6155A6),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const SignInPage();
                              }));
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ImailInput(
                    hintText: 'Write your email address',
                    icon: emailOutlined,
                    labelText: 'Email',
                    onChanged: setEmail,
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
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
                            child: ElevatedButton.icon(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                padding: MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.only(right: 8)),
                              ),
                              onPressed: () {
                                print("signup");
                              },
                              icon: const Image(
                                image: AssetImage(
                                  'assets/logos/google_light.png',
                                  package: 'flutter_signin_button',
                                ),
                              ),
                              label: const Text(
                                'Google',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0F1D27),
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
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
                            child: ElevatedButton.icon(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                padding: MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.only(right: 8)),
                              ),
                              onPressed: () {
                                print("apple");
                              },
                              icon: const Icon(
                                apple,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Apple',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0F1D27),
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Container(
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
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }));
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
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }));
                          },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    });
  }
}
