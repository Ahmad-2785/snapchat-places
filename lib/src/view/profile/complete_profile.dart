import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:snapchat/src/res/routes/routes.dart';

import '../../data/shared_pref/shared_pref.dart';
// import '../../util/utils.dart';
// import '../../view_model/services/splash_services.dart';
import 'components/custom_input_decoration.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  void initState() {
    super.initState();
    // SplashServices.checkProfile();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  // final picker = ImagePicker();

  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = basename(_imageFile!.path);
  //   final firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('avatar/$fileName');
  //   final uploadTask = firebaseStorageRef.putFile(_imageFile!);
  //   final taskSnapshot = uploadTask.snapshot;
  //   await taskSnapshot.ref.getDownloadURL().then(
  //         (value) => print("Done: $value"),
  //       );
  // }

  // void _directUpdateImage(File? file) async {
  //   if (file == null) {
  //     return;
  //   } else {
  //     _imageFile = file;
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Replace with your image path
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
                      'Complete profile',
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
                  const Text(
                    'Fill out the below form to complete your profile',
                    style: TextStyle(
                      color: Color(0xFF0F1D27),
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 24,
                  // ),
                  SizedBox(
                    height: 140,
                    child: Stack(children: [
                      Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFFFF7FC),
                            shape: OvalBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFECEEEF))),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 96,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                    as ImageProvider<Object>
                                : const AssetImage('assets/images/avatar.png'),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 96,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              XFile? pickedImage = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                _imageFile = File(pickedImage!.path);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              radius: 20,
                              child: const Icon(
                                IconData(0xf29b, fontFamily: 'MaterialIcons'),
                                // color: Colors.white,
                                size: 24,
                              ),
                            ),
                          )),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
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
                        // const SizedBox(height: 10),
                        // FormBuilderTextField(
                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                        //   name: 'email',
                        //   decoration: CustomInputDecoration(
                        //     'Enter recovery Email',
                        //     Icon(
                        //       Icons.mail_outline_outlined,
                        //       color: Color(0xFFA7ACAF),
                        //     ),

                        //   ),
                        //   validator: FormBuilderValidators.compose([
                        //     FormBuilderValidators.required(),
                        //     FormBuilderValidators.email(),
                        //   ]),
                        // ),
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
                        const SizedBox(height: 16),
                        const Text(
                          'Repeat recovery password',
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
                          name: 'confirm_password',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: CustomInputDecoration(
                            'Enter recovery password again',
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFFA7ACAF),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) => _formKey.currentState
                                      ?.fields['password']?.value !=
                                  value
                              ? 'No coinciden'
                              : null,
                        ),
                        const SizedBox(height: 20),
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
                              onPressed: completeProfile,
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF6155A6))),
                              child: const Text(
                                'Complete Profile',
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
                        Container(
                          decoration: ShapeDecoration(
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
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFEFEEF6))),
                              onPressed: () {},
                              child: Text(
                                'Recovery',
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

  void completeProfile() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // _formKey.currentState?.fields['username']
      //     ?.invalidate('Username already taken.');
      final fireUser = FirebaseAuth.instance.currentUser;
      final providerID = fireUser!.providerData[0].providerId;
      final uid = fireUser.uid;
      final username = _formKey.currentState?.value['username'];
      final password = _formKey.currentState?.value['password'];
      String extenstion = extension(_imageFile!.path);
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('avatar/$uid.$extenstion');
      final uploadTask = firebaseStorageRef.putFile(_imageFile!);
      final taskSnapshot = uploadTask.snapshot;
      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('Users').add({
        'uid': uid,
        'username': username,
        'provider': providerID,
        'password': password,
        'avatar': downloadURL
      }).then((DocumentReference doc) {
        UserPref.setUser(
            uid, doc.id, providerID, username, password, downloadURL);
        // Utils.showSnackBar(
        //     'Login',
        //     'Successfully Login',
        //     const Icon(
        //       IconData(0xf04be, fontFamily: 'MaterialIcons'),
        //       color: Color(0xFF6155A6),
        //     ));
        Get.toNamed(Routes.homePage);
      }).onError((error, stackTrace) {
        // Utils.showSnackBar(
        //     'Error',
        //     Utils.extractFirebaseError(error.toString()),
        //     const Icon(
        //       IconData(0xf04be, fontFamily: 'MaterialIcons'),
        //       color: Color(0XFFFD363B),
        //     ));
        return;
      });
    }
  }
}
