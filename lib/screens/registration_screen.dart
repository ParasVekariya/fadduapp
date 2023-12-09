import 'package:fadduapp/provider/internet_provider.dart';
import 'package:fadduapp/provider/sign_in_provider.dart';
import 'package:fadduapp/screens/home_screen.dart';
import 'package:fadduapp/screens/login_screen.dart';
import 'package:fadduapp/utils/next_screen.dart';
import 'package:fadduapp/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  final FocusNode _myFocusNodesec = FocusNode();
  final ValueNotifier<bool> _myFocusNotifiersec = ValueNotifier<bool>(false);

  final FocusNode _myFocusNodefir = FocusNode();
  final ValueNotifier<bool> _myFocusNotifierfir = ValueNotifier<bool>(false);

  final FocusNode _myFocusNodeem = FocusNode();
  final ValueNotifier<bool> _myFocusNotifierem = ValueNotifier<bool>(false);

  final FocusNode _myFocusNodepas = FocusNode();
  final ValueNotifier<bool> _myFocusNotifierpas = ValueNotifier<bool>(false);

  final FocusNode _myFocusNodecpas = FocusNode();
  final ValueNotifier<bool> _myFocusNotifiercpas = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _myFocusNodesec.addListener(_onFocusChangesec);
    _myFocusNodefir.addListener(_onFocusChangefir);
    _myFocusNodeem.addListener(_onFocusChangeem);
    _myFocusNodepas.addListener(_onFocusChangepas);
    _myFocusNodecpas.addListener(_onFocusChangecpas);
  }

  void _onFocusChangesec() {
    _myFocusNotifiersec.value = _myFocusNodesec.hasFocus;
  }

  void _onFocusChangefir() {
    _myFocusNotifierfir.value = _myFocusNodefir.hasFocus;
  }

  void _onFocusChangeem() {
    _myFocusNotifierem.value = _myFocusNodeem.hasFocus;
  }

  void _onFocusChangepas() {
    _myFocusNotifierpas.value = _myFocusNodepas.hasFocus;
  }

  void _onFocusChangecpas() {
    _myFocusNotifiercpas.value = _myFocusNodecpas.hasFocus;
  }

  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // first name field
    final firstNameField = ValueListenableBuilder(
        valueListenable: _myFocusNotifierfir,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: firstNameEditingController,
            keyboardType: TextInputType.name,
            focusNode: _myFocusNodefir,
            validator: (value) {
              RegExp regex = RegExp(r'^.{3,}$');
              if (value!.isEmpty) {
                return ("Name cannot be empty");
              }
              if (!regex.hasMatch(value)) {
                return ("Min 3  Characters required)");
              }
            },
            onSaved: (value) {
              secondNameEditingController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.account_circle,
                color: Colors.white60,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "First Name",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white60),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus
                  ? const Color.fromARGB(255, 54, 48, 74)
                  : const Color.fromARGB(255, 31, 26, 47),
            ),
          );
        });

    // second name field

    final secondNameField = ValueListenableBuilder(
        valueListenable: _myFocusNotifiersec,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: secondNameEditingController,
            keyboardType: TextInputType.name,
            focusNode: _myFocusNodesec,
            validator: (value) {
              RegExp regex = RegExp(r'^.{3,}$');
              if (value!.isEmpty) {
                return ("Name cannot be empty");
              }
              if (!regex.hasMatch(value)) {
                return ("Min 3  Characters required)");
              }
            },
            onSaved: (value) {
              secondNameEditingController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.account_circle,
                color: Colors.white60,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Second Name",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white60),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus
                  ? const Color.fromARGB(255, 54, 48, 74)
                  : const Color.fromARGB(255, 31, 26, 47),
            ),
          );
        });

    // email field enter
    final emailField = ValueListenableBuilder(
        valueListenable: _myFocusNotifierem,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: emailEditingController,
            keyboardType: TextInputType.emailAddress,
            focusNode: _myFocusNodeem,
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
              emailEditingController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.account_circle,
                color: Colors.white60,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Email",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white60),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus
                  ? const Color.fromARGB(255, 54, 48, 74)
                  : const Color.fromARGB(255, 31, 26, 47),
            ),
          );
        });

    // pass field enter
    final passwordField = ValueListenableBuilder(
        valueListenable: _myFocusNotifierpas,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: passwordEditingController,
            obscureText: true,
            focusNode: _myFocusNodepas,
            validator: (value) {
              RegExp regex = RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password must not be empty");
              }
              if (!regex.hasMatch(value)) {
                return ("Min 6 Characters required)");
              }
            },
            onSaved: (value) {
              passwordEditingController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.security,
                color: Colors.white60,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Password",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white60),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus
                  ? const Color.fromARGB(255, 54, 48, 74)
                  : const Color.fromARGB(255, 31, 26, 47),
            ),
          );
        });

    // confirm pass field enter
    final confirmPasswordField = ValueListenableBuilder(
        valueListenable: _myFocusNotifiercpas,
        builder: (_, isFocus, child) {
          return TextFormField(
            autofocus: false,
            controller: confirmPasswordEditingController,
            obscureText: true,
            focusNode: _myFocusNodecpas,
            validator: (value) {
              if (confirmPasswordEditingController.text !=
                  passwordEditingController.text) {
                return "Password Does Not Match";
              }
              return null;
            },
            onSaved: (value) {
              confirmPasswordEditingController.text = value!;
            },
            style: GoogleFonts.macondo(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.security,
                color: Colors.white60,
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Re-Enter Password",
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white60),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 31, 26, 47)),
                  borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: isFocus
                  ? const Color.fromARGB(255, 54, 48, 74)
                  : const Color.fromARGB(255, 31, 26, 47),
            ),
          );
        });

    // sign up button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 113, 241, 227),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        // minWidth: MediaQuery.of(context).size.width,
        minWidth: MediaQuery.of(context).size.width * 0.40,
        onPressed: () {
          signUp(
              emailEditingController.text,
              passwordEditingController.text,
              firstNameEditingController.text,
              secondNameEditingController.text);
        },
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: GoogleFonts.macondo(
              fontSize: 20,
              color: const Color.fromARGB(255, 31, 26, 47),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 26, 47),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              nextScreenReplace(context, const LoginScreen());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 113, 241, 227),
            )),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color.fromARGB(255, 31, 26, 47),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 85,
                            child: Image.asset(
                              "assets/login.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          firstNameField,
                          const SizedBox(
                            height: 5,
                          ),
                          secondNameField,
                          const SizedBox(
                            height: 5,
                          ),
                          emailField,
                          const SizedBox(
                            height: 5,
                          ),
                          passwordField,
                          const SizedBox(
                            height: 5,
                          ),
                          confirmPasswordField,
                          const SizedBox(
                            height: 5,
                          ),
                          signUpButton
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // when the user want to register
  void signUp(String email, String password, String firstname,
      String secondname) async {
    // internet checks
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();

    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "Check your internet connection", Colors.red);
    } else {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) async => {
                    // if the new user creation is succes full go to
                    postDetailsToFirestore(sp, email, firstname, secondname)
                  })
              .catchError((e) {
            Fluttertoast.showToast(msg: e!.message);
          });
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          Fluttertoast.showToast(msg: errorMessage!);
          print(error.code);
        }
      }
    }
  }

  // Post the details to the fire store with current user in the queue
  Future postDetailsToFirestore(SignInProvider sp, String email,
      String firstname, String secondname) async {
    // call the firestore and
    // send the details to firebase cloud with register function

    String user = FirebaseAuth.instance.currentUser!.uid;
    sp.register(user, email, firstname, secondname);

    sp.checkUserExists().then((value) async {
      if (value == true) {
        // user exits
        await sp.getUserDataFromfirestore(sp.uid).then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
                  nextScreenReplace(context, const HomeScreen());
                })));
      } else {
        // user does not exists
        sp.saveDataToFirestore().then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
                  nextScreenReplace(context, const HomeScreen());
                })));
      }
    });
  }
}
