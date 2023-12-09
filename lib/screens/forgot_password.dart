import 'package:fadduapp/screens/login_screen.dart';
import 'package:fadduapp/utils/next_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:miniproject/components/mybutton.dart';
// import 'package:miniproject/components/mytextfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController eController = new TextEditingController();
  final FocusNode _myFocusNode = FocusNode();
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
    // _passwordFocusNotifier.value = _myFocusNode1.hasFocus;
  }

  @override
  void dispose() {
    eController.dispose();
    super.dispose();
  }

  Future passwordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Password reset link sent!"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 31, 26, 47),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 31, 26, 47),
          // elevation: 0,
          foregroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              nextScreenReplace(context, const LoginScreen());
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back_ios),
            //   onPressed: () {
            //     nextScreenReplace(context, const LoginScreen());
            //   },
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //       onPressed: () {
            //         nextScreenReplace(context, const LoginScreen());
            //       },
            //       icon: Icon(Icons.arrow_back_ios),
            //       // alignment: Alignment.topLeft,
            //       padding: EdgeInsets.only(left: 10, top: 10)),
            // ),
            Text(
              "Enter email for a password reset",
              style: GoogleFonts.macondo(
                color: Color.fromARGB(255, 113, 241, 227),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Color.fromARGB(255, 113, 241, 227),
              //   fontSize: 16,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
            const SizedBox(height: 30),
            // MyTextField(controller: _emailController, hintText: "Email", obscureText: false),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ValueListenableBuilder(
                  valueListenable: _myFocusNotifier,
                  builder: (_, isFocus, child) {
                    return TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: eController,
                      focusNode: _myFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Enter your email address");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.white60),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.white),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 31, 26, 47)),
                            borderRadius: BorderRadius.circular(20)),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.blue, width: 3),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        // fillColor: Colors.grey.shade200,
                        fillColor: isFocus
                            ? const Color.fromARGB(255, 54, 48, 74)
                            : const Color.fromARGB(255, 31, 26, 47),
                        filled: true,
                        hintText: "Enter your email address",
                        hintStyle: const TextStyle(color: Colors.white60),
                      ),
                    );
                  }),
              // child: TextField(
              //   controller: eController,
              //   obscureText: false,
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue, width: 3),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     fillColor: Colors.grey.shade200,
              //     filled: true,
              //     hintText: "Enter your email address",
              //     hintStyle: TextStyle(color: Colors.grey.shade500),
              //   ),
              // ),
            ),
            const SizedBox(height: 40),
            // MyButton(onTap: (){passwordReset(_emailController.text.trim());}, text: "Reset Password")
            GestureDetector(
              onTap: () {
                passwordReset(eController.text.trim());
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 60),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 241, 227),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Password Reset",
                    style: GoogleFonts.macondo(
                      color: const Color.fromARGB(255, 31, 26, 47),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
