import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fadduapp/utils/config.dart';
import 'package:fadduapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class SignInProvider extends ChangeNotifier {
  // instance of firebase auth

  // for facebook part
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final twitterLogin = TwitterLogin(
      apiKey: Config.apikey_twitter,
      apiSecretKey: Config.secretkey_twitter,
      redirectURI: "fadduapp://");

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  // Haserror, error code, provider, uid, email, name , imageURL
  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with the google account

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // excecute our authentication

      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // sign in to firebase user
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values in this instance
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account with us";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error occured while signing in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // sign in with facebook account

  Future _checkForLogin() async {
    final accessToken = await facebookAuth.accessToken;

    _checking = false;

    if (accessToken != null) {
      print(accessToken.toJson());
      final userData = await facebookAuth.getUserData();
      _accessToken = accessToken;
      _userData = userData;
    } else {
      _login();
    }
  }

  Future _login() async {
    final LoginResult result = await facebookAuth.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await facebookAuth.getUserData();
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);

      _checking = false;
    }
  }

  Future _logout() async {
    await facebookAuth.logOut();
    _accessToken = null;
    _userData = null;
  }

  Future signInWithFacebook() async {
    // final LoginResult result = await facebookAuth
    //     .login(permissions: ['email', 'public_profile', 'user_name']);

    final LoginResult result = await facebookAuth.login();
    // ------------------get the profile ------------------
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

    final profile = jsonDecode(graphResponse.body);

    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        await firebaseAuth.signInWithCredential(credential);

        // save the values here

        _name = profile['name'];
        _email = profile['email'];
        _uid = profile['id'];
        // await facebookAuth.login().then((facebookUser) async {
        //   if (facebookUser != null) {
        //     await FacebookAuth.instance
        //         .getUserData()
        //         .then((facebookUserData) async {
        //       if (facebookUser.accessToken != null) {
        //         _imageUrl = facebookUserData['picture']['data']['url'];
        //       }
        //     });
        //   }
        // });
        _imageUrl = profile['picture']['data']['url'];
        _provider = 'FACEBOOK';
        _hasError = false;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account with us";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error occured while signing in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // sign in with twitter

  Future signInWithTwitter() async {
    final AuthResult authResult = await twitterLogin.loginV2();
    if (authResult.status == TwitterLoginStatus.loggedIn) {
      try {
        // final User userDetails =
        //     (await firebaseAuth.signInWithCredential(credential)).user!;
        // final userDetails = authResult.user;
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!);
        // await firebaseAuth.signInWithCredential(credential);
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;
        // if (userDetails != null) {
        // final AuthCredential credential = TwitterAuthProvider.credential(
        //     accessToken: authResult.authToken!,
        //     secret: authResult.authTokenSecret!);
        // await firebaseAuth.signInWithCredential(credential);

        // ---------------------save all the data---------------------
        // if (userDetails != null) {
        _name = userDetails.displayName;

        // NOTWORKING
        _email = firebaseAuth.currentUser!.providerData[0].email;
        // _email = userDetails.email;

        // if (firebaseAuth.currentUser != null) {
        //   // _email = firebaseAuth.currentUser!.email;
        //   _email = firebaseAuth.currentUser!.providerData[0].email;
        // }
        // _email = FirebaseAuth.instance.currentUser!.email;
        _imageUrl = userDetails.photoURL;
        _uid = userDetails.uid;
        _provider = "TWITTER";
        _hasError = false;
        notifyListeners();
        //  } else {
        //   print("User is null");
        // }
        // }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account with us";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error occured while signing in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }
  // ---------------------------Entry for cloud firestore---------------------------

  Future getUserDataFromfirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      // print("choosle");
      // print(snapshot);
      _uid = snapshot['uid'];
      _name = snapshot['name'];
      _email = snapshot['email'];
      _imageUrl = snapshot['image_url'];
      _provider = snapshot['provider'];
    });
  }

  Future dbFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
            });
  }

  // ----------------------------Non existing user----------------------------

  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    // await s.setString('name', _name!);
    // await s.setString('email', _email!);
    // await s.setString('uid', _uid!);
    // await s.setString('image_url', _imageUrl!);
    // await s.setString('provider', _provider!);
    if (_name != null) {
      await s.setString('name', _name!);
    }

    if (_email != null) {
      await s.setString('email', _email!);
    }

    if (_uid != null) {
      await s.setString('uid', _uid!);
    }

    if (_imageUrl != null) {
      await s.setString('image_url', _imageUrl!);
    }

    if (_provider != null) {
      await s.setString('provider', _provider!);
    }

    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _imageUrl = s.getString('image_url');
    notifyListeners();
  }

  //check if the user base exits or not in firestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("Existing User");
      return true;
    } else {
      print("New User");
      return false;
    }
  }

  // singout funtion
  Future userSignOut() async {
    await firebaseAuth.signOut;
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();

    // clear all the storage information
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageUrl = "null";
    _uid = user.phoneNumber;
    _provider = "Phone";
    notifyListeners();
  }

  void register(uid, email, firstname, secondname) {
    _name = firstname + " " + secondname;
    _email = email;
    _imageUrl = "null";
    _uid = uid;
    _provider = "Register";
    notifyListeners();
  }
}
