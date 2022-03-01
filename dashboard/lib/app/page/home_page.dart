import 'package:dashboard/app/database/database.dart';
import 'package:dashboard/app/database/users.dart';
import 'package:dashboard/app/models/loading.dart';
import 'package:dashboard/app/page/dashboard_page.dart';
import 'package:dashboard/app/page/log_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool subscribeReddit = false;
  bool subscribeWeather = false;
  bool subscribeMovie = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found in database.");
    final database = DatabaseService(user.uid);

    final subscribeRedditButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: StreamBuilder<AppUserData>(
        stream: database.user,
        builder: (context, snapshot) {
        if (snapshot.hasData) {
            AppUserData? userData = snapshot.data;
            if (userData == null) return Loading();
            if (userData.redditService == "false") {
              subscribeReddit = false;
            } else {
              subscribeReddit = true;
            }
              return MaterialButton(
                onPressed: () async {
                  if (subscribeReddit == true) {
                    await database.saveUser(userData.email, userData.movieService, 'false', userData.uid, userData.weatherService);
                  } else {
                    await database.saveUser(userData.email, userData.movieService, 'true', userData.uid, userData.weatherService);
                  }
                  setState(() {
                    subscribeReddit = !subscribeReddit;
                  });
                },
                child: Text((subscribeReddit == false) ? "Subscribe": "Unsubscribe", textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                color: (subscribeReddit == false) ? Colors.redAccent : Colors.green,
              );}
            else {
              return Container();
            }
      }),
    );

    final subscribeWeatherButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: StreamBuilder<AppUserData>(
        stream: database.user,
        builder: (context, snapshot) {
        if (snapshot.hasData) {
            AppUserData? userData = snapshot.data;
            if (userData == null) return Loading();
            if (userData.weatherService == "false") {
              subscribeWeather = false;
            } else {
              subscribeWeather = true;
            }
              return MaterialButton(
                onPressed: () async {
                  if (subscribeWeather == true) {
                    await database.saveUser(userData.email, userData.movieService, userData.redditService, userData.uid, 'false');
                  } else {
                    await database.saveUser(userData.email, userData.movieService, userData.redditService, userData.uid, 'true');
                  }
                  setState(() {
                    subscribeWeather = !subscribeWeather;
                  });
                },
                child: Text((subscribeWeather == false) ? "Subscribe": "Unsubscribe", textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                color: (subscribeWeather == false) ? Colors.redAccent : Colors.green,
              );}
            else {
              return Container();
            }
      }),
    );

    final subscribeMovieButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: StreamBuilder<AppUserData>(
        stream: database.user,
        builder: (context, snapshot) {
        if (snapshot.hasData) {
            AppUserData? userData = snapshot.data;
            if (userData == null) return Loading();
            if (userData.movieService == "false") {
              subscribeMovie = false;
            } else {
              subscribeMovie = true;
            }
              return MaterialButton(
                onPressed: () async {
                  if (subscribeMovie == true) {
                    await database.saveUser(userData.email, 'false', userData.redditService, userData.uid, userData.weatherService);
                  } else {
                    await database.saveUser(userData.email, 'true', userData.redditService, userData.uid, userData.weatherService);
                  }
                  setState(() {
                    subscribeMovie = !subscribeMovie;
                  });
                },
                child: Text((subscribeMovie == false) ? "Subscribe": "Unsubscribe", textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                color: (subscribeMovie == false) ? Colors.redAccent : Colors.green,
              );}
            else {
              return Container();
            }
      }),
    );

  final genepiButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
        },
        child: const Text("Go to Genepiboard", textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
    appBar: AppBar(
        title: const Text("You are logged in."),
        centerTitle: true,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
            primary: Colors.black,
            ),
            child: const Text('Logout'),
            onPressed: () {
              logout(context);
            },
          )
        ],
      ),
        body: Column(
          children: <Widget>[
            Container(
              height: 230,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50)),
                color: Colors.blue,
              ),
              child: Stack(
                children: [
                  Positioned(top: 80, left: 0, 
                  child: Container(
                    height: 100, width: 700, decoration: const BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )
                    ),
                  )),
                  const Positioned(
                    top: 100,
                    left: 25,
                    child: Text("Welcome to Genepiboard", style: TextStyle(fontSize: 50, color: Colors.blue, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 120),
                Expanded(
                child: Container(
                  height: 600,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 35,
                        child: Material(
                        child: Container(
                          height: 550,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(-10, 10),
                              blurRadius: 20,
                              spreadRadius: 4)],
                          ),
                        ),
                      )),
                      Positioned(
                        left: 100,
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            height: 200,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(image: AssetImage("logo-reddit.png"))
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 70,
                        child: Container(
                          height: 300,
                            width: 350,
                          child: Column(
                            children: [
                              const Text("Reddit Service", style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const Text("This service will allow you to get a subreddit's description or a reddit user profile picture",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const SizedBox(height: 90),
                              subscribeRedditButton,
                            ],
                          ),
                      )),
                    ],
                  ),
                )
              ),
                Expanded(
                child: Container(
                  height: 600,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 35,
                        child: Material(
                        child: Container(
                          height: 550,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(-10, 10),
                              blurRadius: 20,
                              spreadRadius: 4)],
                          ),
                        ),
                      )),
                      Positioned(
                        left: 100,
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            height: 200,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(image: AssetImage("movie-logo.png"))
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 70,
                        child: Container(
                          height: 300,
                            width: 350,
                          child: Column(
                            children: [
                              const Text("Movie Service", style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const Text("This service will tell you the description of a movie of your choice and its release date",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const SizedBox(height: 90),
                              subscribeMovieButton,
                            ],
                          ),
                      )),
                    ],
                  ),
                )
              ),
                Expanded(
                child: Container(
                  height: 600,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 35,
                        child: Material(
                        child: Container(
                          height: 550,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(-10, 10),
                              blurRadius: 20,
                              spreadRadius: 4)],
                          ),
                        ),
                      )),
                      Positioned(
                        left: 100,
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            height: 200,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(image: AssetImage("weather-logo.jpg"))
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 70,
                        child: Container(
                          height: 300,
                          width: 350,
                          child: Column(
                            children: [
                              const Text("Weather Service", style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const Text("This service will give you information about the weather in a certain city such as temperature and humidity",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const SizedBox(height: 20),
                              subscribeWeatherButton,
                            ],
                          ),
                      )),
                    ],
                  ),
                )
              ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(800, 0, 800, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  genepiButton,
                ],
              ),
            ),
          ]
        ),
      //),
     ),
    );
  }

  Future<void> logout(BuildContext context) async {  
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticateScreen()));
  }
}