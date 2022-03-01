import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/provider/google_sign_in.dart';
import 'app/page/log_page.dart';

/// Main function of the program that will initialize Firebase
Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAQdwTu77ThEJWgquRiljvtYQqJqV2Jarc',
      appId: '1:573725812105:web:5f5adb47bd11440462ad58',
      messagingSenderId: '573725812105',
      projectId: 'dashboard-1cd77',
    ),
  );
  runApp(MyApp());
}

/// First Class that will handle the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      title: 'Genepiboard',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticateScreen(),
        // '/about.json': (context) => const GetAboutJson(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const AuthenticateScreen(), //material app
    ), // ChangeNotifierProvider
  );
}