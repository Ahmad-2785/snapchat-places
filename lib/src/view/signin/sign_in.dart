import 'package:flutter/material.dart';
import 'components/signin_body.dart';


class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignInBody(),
      ),
    );
  }
}
