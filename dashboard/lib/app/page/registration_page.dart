import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/app/page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';

/// Class handling user registration
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  /// Create User in Firebase
  final _auth = FirebaseAuth.instance;

  /// Key
  final _formKey = GlobalKey<FormState>();

  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

  /// Email Field to be filled
  final emailField = TextFormField(
    autofocus: false, 
    controller: emailEditingController, 
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value!.isEmpty) {
        return ("Please Enter Your Email");
      }
      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
        return ("Please Enter a valid email");
      }
      return null;
    },
    onSaved: (value) {
      emailEditingController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.mail),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Email",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

  /// Password Field to be filled
  final passwordField = TextFormField(
    autofocus: false,
    controller: passwordEditingController,
    obscureText: true,
    validator: (value) {
      RegExp regex = RegExp(r'^.{6,}$');
      if (value!.isEmpty) {
        return ("Password is required for login");
      }
      if (!regex.hasMatch(value)) {
        return ("Enter Valide Password(Min. 6 Character)");
      }
    },
    onSaved: (value) {
      passwordEditingController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.vpn_key),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "password",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

  /// Confirm Password Field to be filled
  final confirmPasswordField = TextFormField(
    autofocus: false, 
    controller: confirmPasswordEditingController,
    obscureText: true,
    validator: (value) {
      if (confirmPasswordEditingController.text != passwordEditingController.text) {
        return ("Password don't match");
      }
      return null;
    },
    onSaved: (value) {
      confirmPasswordEditingController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.vpn_key),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "confirm password",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text("SignUp", textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: Center (
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(800, 0, 800, 0),
            child: Form(
              key: _formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: Image.asset("assets/logo.png",
                    fit: BoxFit.contain)),
                    const SizedBox(height: 25),
                  emailField,
                  const SizedBox(height: 25),
                  passwordField,
                  const SizedBox(height: 25),
                  confirmPasswordField,
                  const SizedBox(height: 25),
                  signUpButton,
                  const SizedBox(height: 15)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  /// This function will add the user to the Firestore database
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
        postDetailsToFirestore()
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  /// This will create a Firestore instance to add user and its information such as which services he is subscribed to
  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    /// The user gotten from FirebaseAuth
    User? user = _auth.currentUser;
    
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.redditService = "false";
    userModel.movieService = "false";
    userModel.weatherService = "false";

    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
  }
} 