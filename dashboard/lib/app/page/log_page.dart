import 'package:dashboard/app/page/home_page.dart';
import 'package:dashboard/app/page/registration_page.dart';
import 'package:provider/provider.dart';
import '../provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// This class will handle the user authentification and send him to the right page
class AuthenticatePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                    return const HomeScreen();
                } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong.'));
                } else {
                    return const AuthenticateScreen();
                }
            },
        ),
    );
}

/// This class will display the fields to be filled to log in
class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreen();
}

class _AuthenticateScreen extends State<AuthenticateScreen> {
  final _formKey = GlobalKey<FormState>();

  /// This bool waits for the authentification to finish 
  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// To get the user's information
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    
    final emailField = TextFormField(
    autofocus: false, 
    controller: emailController, 
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
      emailController.text = value!;
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

    final passwordField = TextFormField(
    autofocus: false, 
    controller: passwordController,
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
      passwordController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.vpn_key),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Password",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text("Login", textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

  return Scaffold(
    backgroundColor: Colors.white,
    body: Center (
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(800, 0, 800, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  loginButton,
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account? "),
                      GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                      },
                        child: const Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      signInGoogle();
                      },
                    child: const Text('Sign in with Google')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  /// This function will handle the sign in with normal OAuth
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen())),
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      }); 
    }
  }
  /// This function will handle the sign in with Google OAuth2
  void signInGoogle() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    await provider.googleLogin();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}