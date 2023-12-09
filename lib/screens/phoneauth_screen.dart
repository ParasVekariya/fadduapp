import 'dart:io';

import 'package:fadduapp/provider/internet_provider.dart';
import 'package:fadduapp/provider/sign_in_provider.dart';
import 'package:fadduapp/screens/home_screen.dart';
import 'package:fadduapp/screens/login_screen.dart';
import 'package:fadduapp/utils/config.dart';
import 'package:fadduapp/utils/next_screen.dart';
import 'package:fadduapp/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formKey = GlobalKey<FormState>();

  // controller needed here --> for phone, name,email, otp code

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              nextScreenReplace(context, const LoginScreen());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(
                    Config.app_icon,
                  ),
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Phone Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                // ------------------------for name part------------------------
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "Name cannot be empty";
                    return null;
                  },
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle),
                      hintText: "Jethalal Gada",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      )),
                ),

                // ------------------------for email part------------------------
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "Email address cannot be empty";
                    return null;
                  },
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_rounded),
                      hintText: "jg@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      )),
                ),

                // ------------------------for phone part------------------------
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "Phone Number cannot be empty";
                    return null;
                  },
                  controller: phoneController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "+1 1234567890",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      login(context, phoneController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: const Text(
                      "Be a part of my app",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();

    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Check your internet connection", Colors.red);
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackBar(context, e.toString(), Colors.red);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Enter the code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: otpCodeController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.comment_rounded),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final code = otpCodeController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;

                              // Save the values
                              sp.phoneNumberUser(user, emailController.text,
                                  nameController.text);

                              // check whether the user exist or not
                              sp.checkUserExists().then((value) async {
                                if (value == true) {
                                  // user exits
                                  await sp
                                      .getUserDataFromfirestore(sp.uid)
                                      .then((value) => sp
                                          .saveDataToSharedPreferences()
                                          .then((value) =>
                                              sp.setSignIn().then((value) {
                                                nextScreenReplace(context,
                                                    const HomeScreen());
                                              })));
                                } else {
                                  // user does not exists
                                  sp.saveDataToFirestore().then((value) => sp
                                      .saveDataToSharedPreferences()
                                      .then((value) =>
                                          sp.setSignIn().then((value) {
                                            nextScreenReplace(
                                                context, const HomeScreen());
                                          })));
                                }
                              });
                            },
                            child: const Text("Lock kiya jaye"),
                          )
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
