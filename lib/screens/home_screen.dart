// import "package:cloud_firestore/cloud_firestore.dart";
import "package:fadduapp/provider/sign_in_provider.dart";
import "package:fadduapp/screens/login_screen.dart";
import "package:fadduapp/utils/next_screen.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // change read to watch
    final sp = context.watch<SignInProvider>();
    // debug purpose
    print("----------------------------------------------------------------");
    print(user.uid);
    print("----------------------------------------------------------------");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 26, 47),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 31, 26, 47),
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Welcome ${sp.name}",
              style: GoogleFonts.macondo(
                  color: const Color.fromARGB(255, 113, 241, 227),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${sp.email}",
              style: GoogleFonts.macondo(
                  color: const Color.fromARGB(255, 113, 241, 227),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${sp.uid}",
              style: GoogleFonts.macondo(
                  color: const Color.fromARGB(255, 113, 241, 227),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Provider:",
                  style: GoogleFonts.macondo(
                      color: const Color.fromARGB(255, 113, 241, 227),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "${sp.provider}",
                  style: GoogleFonts.macondo(
                      color: const Color.fromARGB(255, 240, 112, 126),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 113, 241, 227)),
              onPressed: () {
                sp.userSignOut();
                nextScreenReplace(context, const LoginScreen());
              },
              child: Wrap(
                children: [
                  const Icon(
                    FontAwesomeIcons.signOut,
                    size: 20,
                    color: Color.fromARGB(255, 31, 26, 47),
                  ),
                  const SizedBox(
                    height: 10,

                    // how to add coloured backgorund here
                    // child: ColoredBox(
                    //   color: Colors.blue,
                    // ),
                  ),
                  Text(
                    "SIGNOUT",
                    style: GoogleFonts.macondo(
                        color: const Color.fromARGB(255, 31, 26, 47),
                        // backgroundColor: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
