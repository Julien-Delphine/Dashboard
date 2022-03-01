import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This class manages google to allow OAuth2 authentification with google account
class GoogleSignInProvider extends ChangeNotifier {
    /// Initialize google sign in
    final googleSignIn = GoogleSignIn();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    GoogleSignInAccount ? _user;

    GoogleSignInAccount ? get user => _user;

    /// This method will link the google sign in to FirebaseAuth Database
    Future googleLogin() async {
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
            return;
        }
        _user = googleUser;

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        postDetailsToFirestore();
        notifyListeners();
    }

    /// Function to sign out of Google
    Future logout() async {
        await googleSignIn.disconnect();
        FirebaseAuth.instance.signOut();
    }

    /// This will send to the Firestore Database all of the user's information on sign in
    postDetailsToFirestore() async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      User? user = auth.currentUser;

      UserModel userModel = UserModel();

      userModel.email = auth.currentUser!.providerData[0].email.toString();
      userModel.uid = user!.uid;
      userModel.redditService = "false";
      userModel.movieService = "false";
      userModel.weatherService = "false";

      firebaseFirestore.collection('users').doc(user.uid).get().then((value) async {
        if (value.data() == null) {
          await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
        }
        else {
          return;
        }
      });
  }
}