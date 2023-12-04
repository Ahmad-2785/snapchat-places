import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:snapchat/src/data/shared_pref/shared_pref.dart';
import 'package:snapchat/src/util/utils.dart';
import 'package:snapchat/src/view/home/home.dart';
import 'package:snapchat/src/view/profile/components/custom_input_decoration.dart';

class RecoveryProfile extends StatefulWidget {
  const RecoveryProfile({super.key});

  @override
  State<RecoveryProfile> createState() => _RecoveryProfileState();
}

class _RecoveryProfileState extends State<RecoveryProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 88,
                    child: Center(
                        child: Text(
                      'Recovery',
                      style: TextStyle(
                        color: Color(0xFF0F1D27),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            color: Color(0xFF3D4850),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          name: 'username',
                          showCursor: false,
                          decoration: CustomInputDecoration(
                            'Enter your username',
                            const Icon(
                              Icons.person_outlined,
                              color: Color(0xFFA7ACAF),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.match(
                              r'^[a-zA-Z0-9]+$',
                              errorText:
                                  'Username should only contain letters and numbers',
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Recovery password',
                          style: TextStyle(
                            color: Color(0xFF3D4850),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        FormBuilderTextField(
                          showCursor: false,
                          name: 'password',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: CustomInputDecoration(
                            'Enter recovery password',
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFFA7ACAF),
                            ),
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(6,
                                errorText: 'At least six letter'),
                          ]),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).colorScheme.primary,
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
                              onPressed: recoveryProfile,
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF6155A6))),
                              child: const Text(
                                'Recovery',
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
                      ],
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

  void recoveryProfile() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fireUser = FirebaseAuth.instance.currentUser;
      final providerID = fireUser!.providerData[0].providerId;
      final uid = fireUser.uid;
      final username = _formKey.currentState?.value['username'];
      final password = _formKey.currentState?.value['password'];
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();
      if (snapshot.docs.isEmpty) {
        Utils.showSnackBar(
            const Text(
              'Error',
              style: TextStyle(
                color: Color(0xFF0F1D27),
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            const Text(
              "Invalid Username and Password",
              style: TextStyle(
                color: Color(0xFF566067),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const Icon(
              Icons.error,
              color: Colors.red,
            ));
        return;
      }
      final data = snapshot.docs[0].data() as Map<String, dynamic>;
      final avatar = data['avatar'];
      FirebaseFirestore.instance.collection('Users').add({
        'uid': uid,
        'username': username,
        'provider': providerID,
        'password': password,
        'avatar': avatar
      }).then((DocumentReference doc) {
        UserPref.setUser(uid, username, avatar);
        Get.offAll(() => const HomePage());
      }).onError((error, stackTrace) {
        return;
      });
    }
  }
}
