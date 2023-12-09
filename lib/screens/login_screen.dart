import "package:fadduapp/provider/internet_provider.dart";
import "package:fadduapp/provider/sign_in_provider.dart";
import "package:fadduapp/screens/forgot_password.dart";
import "package:fadduapp/screens/home_screen.dart";
import "package:fadduapp/screens/phoneauth_screen.dart";
import 'package:fadduapp/screens/registration_screen.dart';
import "package:fadduapp/utils/next_screen.dart";
import "package:fadduapp/utils/snack_bar.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:rounded_loading_button/rounded_loading_button.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // for simple email login
  late FocusNode _myFocusNode;
  final FocusNode _myFocusNode1 = FocusNode();
  final ValueNotifier<bool> _passwordFocusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Focus nodes are used to chnage the colour of text box when focused
    // this is acheived using focus node and fou=cus notifier

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
    // _myFocusNode1 = FocusNode();
    _myFocusNode1.addListener(_onFocusChangepass);
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  void _onFocusChangepass() {
    _passwordFocusNotifier.value = _myFocusNode1.hasFocus;
  }

  // editing controllers
  final TextEditingController eController = new TextEditingController();
  final TextEditingController pController = new TextEditingController();

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    Color efC = const Color.fromARGB(255, 31, 26, 47);
    // ------------------for email part ------------------
    final efield = ValueListenableBuilder(
        valueListenable: _myFocusNotifier,
        builder: (_, isFocus, child) {
          return TextFormField(
              autofocus: false,
              controller: eController,
              keyboardType: TextInputType.emailAddress,
              focusNode: _myFocusNode,
              onEditingComplete: () {
                _myFocusNode.removeListener(_onFocusChange);
                _myFocusNode.dispose();
                _myFocusNotifier.dispose();
              },
              // null check and valid address checker
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
              onSaved: (value) {
                eController.text = value!;
              },
              style: GoogleFonts.macondo(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.white60),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white60),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 31, 26, 47)),
                    borderRadius: BorderRadius.circular(20)),
                filled: true,
                fillColor:
                    isFocus ? const Color.fromARGB(255, 54, 48, 74) : efC,
              ));
        });

    //------------------ for pass part------------------

    final pfield = ValueListenableBuilder(
        valueListenable: _passwordFocusNotifier,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: pController,
            obscureText: true,
            focusNode: _myFocusNode1,
            // null check and min length password checker
            validator: (value) {
              RegExp regex = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required for login");
              }
              if (!regex.hasMatch(value)) {
                return ("Min 6 Characters required)");
              }
            },
            onSaved: (value) {
              pController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            onEditingComplete: () {
              _myFocusNode1.removeListener(_onFocusChangepass);
              _myFocusNode1.dispose();
              _passwordFocusNotifier.dispose();
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.vpn_key_rounded),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Password",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus ? const Color.fromARGB(255, 54, 48, 74) : efC,
            ),
          );
        });

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 113, 241, 227),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signInEP(eController.text, pController.text);
        },
        child: Text(
          'Login',
          style: GoogleFonts.macondo(
              color: Color.fromARGB(255, 31, 26, 47),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 31, 26, 47),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 31, 26, 47),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                          child: Image.asset(
                            "assets/login.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        efield,
                        const SizedBox(
                          height: 10,
                        ),
                        pfield,
                        const SizedBox(
                          height: 10,
                        ),
                        loginButton,
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Text(
                            'Forgot Password',
                            style: GoogleFonts.macondo(
                              color: Color.fromARGB(255, 113, 241, 227),
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            nextScreenReplace(
                                context, const ForgotPasswordPage());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ADDING Rounded Buttons
              Row(
                // adding the buttons for google, facebok, twitter, phone
                children: [
                  const Expanded(
                      child: Divider(
                    thickness: 1.5,
                    color: Color.fromARGB(255, 240, 112, 126),
                  )),
                  Text(
                    'Or Continue With',
                    style: GoogleFonts.macondo(
                        color: const Color.fromARGB(255, 113, 241, 227),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  const Expanded(
                      child: Divider(
                    thickness: 1.5,
                    color: Color.fromARGB(255, 240, 112, 126),
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                    onPressed: () {
                      handleGoogleSignIn();
                    },
                    controller: googleController,
                    // successColor: Colors.red,
                    successColor: const Color.fromARGB(255, 113, 241, 227),
                    width: MediaQuery.of(context).size.width * 0.30,
                    // width: 15,
                    elevation: 0,
                    borderRadius: 25,
                    color: const Color.fromARGB(255, 113, 241, 227),
                    child: Wrap(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                border: Border.all(
                                  // color: Colors.red,
                                  color:
                                      const Color.fromARGB(255, 113, 241, 227),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Icon(
                                // adding a icon
                                FontAwesomeIcons.google,
                                size: 20,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                  ),
                  // Facebook login button
                  const SizedBox(
                    height: 10,
                    width: 5,
                  ),
                  RoundedLoadingButton(
                    onPressed: () {
                      handleFacebookAuth();
                    },
                    controller: facebookController,
                    successColor: Colors.blue,
                    width: MediaQuery.of(context).size.width * 0.30,
                    elevation: 0,
                    borderRadius: 25,
                    color: Colors.blue,
                    child: Wrap(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              // adding a icon
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  ------------------ twitter login button ------------------
                  const SizedBox(
                    height: 10,
                    width: 5,
                  ),
                  RoundedLoadingButton(
                    onPressed: () {
                      handleTwitterAuth();
                    },
                    controller: twitterController,
                    successColor: Colors.greenAccent,
                    width: MediaQuery.of(context).size.width * 0.30,
                    // width: 15,
                    elevation: 0,
                    borderRadius: 25,
                    color: Colors.greenAccent,
                    child: Wrap(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                // adding a icon
                                FontAwesomeIcons.twitter,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),

                  //  ------------------ PHONE LOGIN ------------------
                  const SizedBox(
                    height: 10,
                    width: 5,
                  ),
                  RoundedLoadingButton(
                    onPressed: () {
                      nextScreenReplace(context, const PhoneAuthScreen());
                      phoneController.reset();
                    },
                    controller: phoneController,
                    successColor: Colors.teal,
                    width: MediaQuery.of(context).size.width * 0.30,
                    // width: 15,
                    elevation: 0,
                    borderRadius: 25,
                    color: Colors.teal,
                    child: Wrap(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                // adding a icon
                                FontAwesomeIcons.phone,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // ------------------ New user spifics ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.macondo(
                            color: Color.fromARGB(255, 113, 241, 227),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      nextScreenReplace(context, const RegistrationScreen());
                    },
                    child: Text(
                      "Join Us",
                      style: GoogleFonts.macondo(
                          color: Color.fromARGB(255, 113, 241, 227),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  // ------------------ handling twitter auth ------------------
  Future handleTwitterAuth() async {
    // checks for valid internet
    final sp = context.read<SignInProvider>();
    // internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Internet is Down", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithTwitter().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          twitterController.reset();
        } else {
          // checking whether user is in db or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exits, then pass the fucntion call to handle after sign in
              await sp.getUserDataFromfirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        twitterController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exists , save to shared preferences, then pass to sign in handler
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        twitterController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  //------------------  handling the google sign in ------------------------------------

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    // internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Internet is Down", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          // checking whether user is in db or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exits
              await sp.getUserDataFromfirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exists
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // ------------------ handling the facebookauth ------------------------------------

  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    // internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Internet is Down", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          facebookController.reset();
        } else {
          // checking whether user is in db or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exits
              await sp.getUserDataFromfirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exists
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // ------------------ handle the user after sign in ------------------------------------

  handleAfterSignIn() {
    // 1/2 seconds delay and then transfer to home screen
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }

  //  ------------------ handle the sign for email based login ------------------------------------
  void signInEP(String email, String password) async {
    final sp = context.read<SignInProvider>();
    // internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackBar(context, "Internet is Down", Colors.red);
    } else {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password)
              .then((value) async {
            // sp.checkUserExists().then((value) async {
            //   if (value == true) {
            //     // user exits
            //     await sp.getUserDataFromfirestore(sp.uid).then((value) => sp
            //         .saveDataToSharedPreferences()
            //         .then((value) => sp.setSignIn().then((value) {
            //               handleAfterSignIn();
            //             })));
            //   } else {
            //     // user does not exists
            //     sp.saveDataToFirestore().then((value) => sp
            //         .saveDataToSharedPreferences()
            //         .then((value) => sp.setSignIn().then((value) {
            //               googleController.success();
            //               handleAfterSignIn();
            //             })));
            //   }
            // });
            // if (await sp.checkUserExists()) {
            print(value.user!.uid);
            await sp
                .getUserDataFromfirestore(value.user!.uid)
                .then((value) async {
              print(value);
              sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        handleAfterSignIn();
                      }));
            });
          });
        } catch (e) {
          print('Error with email based login');
        }
      }
    }
  }
}
