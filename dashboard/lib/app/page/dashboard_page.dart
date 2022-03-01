import 'package:dashboard/app/page/log_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';
import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Parent class of the dashboard screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

/// List containing all the widgets
List <Widget>widgetList = [];

/// Index of the widget selected
int optionSelected = widgetList.length - 1;

/// Contains the services to check if the user is subscribed to them or not
List <String>myservices = [];

/// List of button to add widget depending on what services the user is subscribed to
List <Widget>buttonList = [];

/// Map containing user data
Map<String, dynamic>? userData;

/// Child class of DashboardScreen
class _DashboardScreen extends State<DashboardScreen> {
  /// Key
  final _formKey = GlobalKey<FormState>();

  /// auth
  final _auth = FirebaseAuth.instance;

  void refresh() {
    setState(() => {}); 
  }


  @override
  Widget build(BuildContext context) {

    /// create button list based on subscribed services
    get_services().then((val) {
      if (userData == null) {
        userData = val;
        myservices.add(userData!["redditService"]);
        myservices.add(userData!["weatherService"]);
        myservices.add(userData!["movieService"]);
        for (int i = 0; i < myservices.length; i++) {
          if (myservices[i] == "true" && i == 0) {
            buttonList.add(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(RedditDescCall(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Reddit Description widget')
                  ));
            buttonList.add(const SizedBox(width: 15));
            buttonList.add(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(RedditUserCall(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Reddit User widget')
                  ));
                  
            buttonList.add(const SizedBox(width: 15));
          }
          if (myservices[i] == "true" && i == 1) {
            buttonList.add(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(WeatherTempCall(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Weather Temperature widget')
                  ));
                  buttonList.add(const SizedBox(width: 15));
                  buttonList.add(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(WeatherHumCall(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Weather Humidity widget')
                  ));
                  buttonList.add(const SizedBox(width: 15));
          }
          if (myservices[i] == "true" && i == 2) {
            buttonList.add(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(MovieDBCall(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Movie Description widget')
                  ));
                  buttonList.add(const SizedBox(width: 15));
                  buttonList.add(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.add(MovieDBCallDate(widgetList.length, this));
                      });
                    },
                    child: const Text('Add Movie Release Date widget')
                  ));
                  buttonList.add(const SizedBox(width: 15));
          }
          
        }
        buttonList.add(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                    ),
                    onPressed: () {
                      setState(() {
                        widgetList.removeAt(optionSelected);
                      });
                      List <Widget>newIndexList = [];
                      for (int i=0; i < widgetList.length; i++){
                        // Bien ajouter ici si on rajoute des widgets
                        if (widgetList[i] is RedditDescCall) {
                          newIndexList.add(RedditDescCall(i, this));
                        }
                        if (widgetList[i] is WeatherTempCall) {
                          newIndexList.add(WeatherTempCall(i, this));
                        }
                        if (widgetList[i] is WeatherHumCall) {
                          newIndexList.add(WeatherHumCall(i, this));
                        }
                        if (widgetList[i] is RedditUserCall) {
                          newIndexList.add(RedditUserCall(i, this));
                        }
                        if (widgetList[i] is MovieDBCall) {
                          newIndexList.add(MovieDBCall(i, this));
                        }
                        if (widgetList[i] is MovieDBCallDate) {
                          newIndexList.add(MovieDBCallDate(i, this));
                        }
                      } // for loop
                      widgetList = newIndexList;
                    },
                    child: const Text('Delete widget')
                  ));
        refresh();
      }
    });
    return MaterialApp(
      title: 'Your Dashboard',
      debugShowCheckedModeBanner: false,
      //key: UniqueKey(),
      home: Scaffold(
      appBar: AppBar(
          actions: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buttonList,
                         // children
              ), // Row
            const SizedBox(width: 200),
            TextButton(
              style: TextButton.styleFrom(
              primary: Colors.black,
              ),
              child: const Text('Logout'),
              onPressed: () {
                setState(() {
                  buttonList.clear();
                  myservices.clear();
                  widgetList.clear();
                  optionSelected = 0;
                  userData = null;
                });
                logout(context);
              },
            ),
          ],
        ),
        body: Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 465,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
                itemCount: widgetList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: widgetList[index],
                  );
                }
              ),
              
            ],
          ),
        ),
      );
  }

  /// Called when logout button is pressed. Calls Firebase 
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticateScreen()));
  }

  /// This function will get the services to which the user is subscribed
  Future <Map<String, dynamic>?> get_services() async{
    /// Map of user data
    Map<String, dynamic>? userData;
    //// Current user
    User? user = _auth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    /// Await for Firebase to send back the information
    await firebaseFirestore.collection('users').doc(user!.uid).get().then((value) async {
      userData = value.data();
    });
    return (userData);
  }
}

/// Will handle the calls to get a subreddit description (Parent)
class RedditDescCall extends StatefulWidget {
  RedditDescCall(
    this.indexwidg,
    this.logic,
  );
  /// The widget's index
  final indexwidg;
  /// Instance of DashboardScreen to refresh everything
  final _DashboardScreen logic;
  @override
  RedditDescCallState createState() => RedditDescCallState(indexwidg, logic);
}
  
/// Child class of RedditDescCall
class RedditDescCallState extends State<RedditDescCall>{
  RedditDescCallState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's index
  final indexwidg;
  /// Instance of DashboardScreen to refresh everything
  final _DashboardScreen logic;
  /// String containing the result of the request
  String result = "";

  /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Get Subreddit description"), backgroundColor: Colors.deepOrange),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              //displaying input text
              const SizedBox(height: 20),
              Text(result),
              const SizedBox(height: 40),
              ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                    ),
                    onPressed: () {
                      logic.refresh();
                      setState(() {
                        optionSelected = indexwidg;
                        // widgetList.removeAt(widgetList.length - 1);
                      });
                    },
                    child: Text('Select widget :' + indexwidg.toString())
                  ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String subreddit) async {
    /// Response from the node server
    final response = await /*return*/ http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Reddit_desc " + subreddit
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    }
    return response;
  }
}

/// Will handle the calls to get a City temperature (Parent)
class WeatherTempCall extends StatefulWidget {
  WeatherTempCall(
    this.indexwidg,
    this.logic,
  );
  /// The widget's index
  final indexwidg;
  /// Instance of DashboardScreen to refresh everything
  final _DashboardScreen logic;
  @override
  WeatherTempCallState createState() => WeatherTempCallState(indexwidg, logic);
}

/// Child of WeatherTempCall 
class WeatherTempCallState extends State<WeatherTempCall>{
  WeatherTempCallState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final indexwidg;
  final _DashboardScreen logic;
  /// String containing the result of the request
  String result = "";

  /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Get Temperature from city"), backgroundColor: Colors.green),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              //displaying input text
              const SizedBox(height: 20),
              Text(result),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    logic.refresh();
                    setState(() {
                      optionSelected = indexwidg;
                    });
                  },
                  child: Text('Select widget :' + indexwidg.toString())
                ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String city) async {
    /// Response from the node server
    final response = await /*return*/ http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Weather_temp " + city
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    }
    return response;
  }
}

/// Will handle the calls to get a user profile picture (Parent)
class RedditUserCall extends StatefulWidget {
  RedditUserCall(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final indexwidg;
  final _DashboardScreen logic;
  @override
  RedditUserCallState createState() => RedditUserCallState(indexwidg, logic);
}
  
class RedditUserCallState extends State<RedditUserCall>{
  RedditUserCallState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final indexwidg;
  final _DashboardScreen logic;
  /// String containing the result of the request
  String result = "https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png";
  /// Only for the reddit user image to count the number of time the request has been made
  String nb_called = "0";

  /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Get Reddit User Profile image"), backgroundColor: Colors.deepOrange),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              //displaying input text
              Image.network(result, width: 100, height: 100),
              Text(nb_called),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    logic.refresh();
                    setState(() {
                      optionSelected = indexwidg;
                    });
                  },
                  child: Text('Select widget :' + indexwidg.toString())
                ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String reddituser) async {
    /// Response from the node server
    final response = await /*return*/ http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Reddit_user " + reddituser
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body.split(" ")[0];
        nb_called = response.body.split(" ")[1];
      });
    }
    return response;
  }
}


/// Will handle the calls to get a movie description (Parent)
class MovieDBCall extends StatefulWidget {
  MovieDBCall(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final _DashboardScreen logic;
  final indexwidg;
  @override
  MovieDBCallState createState() => MovieDBCallState(indexwidg, logic);
}

/// Child class of MovieDBCall
class MovieDBCallState extends State<MovieDBCall>{
  MovieDBCallState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final indexwidg;
  final _DashboardScreen logic;
  /// String containing the result of the request
  String result = "";

  /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Movie Description"), backgroundColor: Colors.purple),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              //displaying input text
              SizedBox(height: 20),
              Text(result, style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
              SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    logic.refresh();
                    setState(() {
                      optionSelected = indexwidg;
                    });
                  },
                  child: Text('Select widget :' + indexwidg.toString())
                ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String movie) async {
    /// Response from the node server
    final response = await http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Movie " + movie
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    }
    return response;
  }
}

/// Will handle the calls to get a Movie's release date (Parent)
class MovieDBCallDate extends StatefulWidget {
  MovieDBCallDate(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final indexwidg;
  final _DashboardScreen logic;
  @override
  MovieDBCallDateState createState() => MovieDBCallDateState(indexwidg, logic);
}

/// Child of MovieDBCallDate
class MovieDBCallDateState extends State<MovieDBCallDate>{
  MovieDBCallDateState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final _DashboardScreen logic;
  final indexwidg;
  /// String containing the result of the request
  String result = "";
  
    /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Movie Release Date"), backgroundColor: Colors.purple),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              //displaying input text
              const SizedBox(height: 20),
              Text(result, style: const TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    logic.refresh();
                    setState(() {
                      optionSelected = indexwidg;
                    });
                  },
                  child: Text('Select widget :' + indexwidg.toString())
                ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String movie) async {
    /// Response from the node server
    final response = await http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Movie_date " + movie
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    }
    return response;
  }
}

/// Will handle the calls to get a City's humidity (Parent)
class WeatherHumCall extends StatefulWidget {
  WeatherHumCall(
    this.indexwidg,
    this.logic,
  );
  /// The widget's index
  final indexwidg;
  /// Instance of DashboardScreen to refresh everything
  final _DashboardScreen logic;
  @override
  WeatherHumCallState createState() => WeatherHumCallState(indexwidg, logic);
}

/// Child of WeatherHumCall
class WeatherHumCallState extends State<WeatherHumCall>{
  WeatherHumCallState(
    this.indexwidg,
    this.logic,
  );
  /// The widget's indexnal _DashboardScreen logic;
  final _DashboardScreen logic;
  final indexwidg;
  /// String containing the result of the request
  String result = "";

  /// String containing the text entered in the box to do the request with the same parameters
  String textrefresh = "";
  /// The number of seconds to be waited between each new request
  int refreshrate = 0;
  /// Timer
  Timer ?timer;

  /// Bool to remove the alert box after the timer is set
  bool show_timer = true;

  /// Function to do a call based on the timer
  void refreshhere() {
    timer = Timer.periodic(Duration(seconds: refreshrate), (Timer t) => {
      if (textrefresh != "") {
        _makePostRequest(textrefresh)
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Get Humidity from city"), backgroundColor: Colors.green),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: show_timer,
                child: AlertDialog( 
                  title: const Text('Refresh rate (seconds)'), 
                  actions: [
                    TextField( 
                    onSubmitted: (String time) { 
                      setState(() {
                        refreshrate = int.parse(time);
                      });
                      refreshhere();
                      show_timer = false;
                      }, 
                      decoration: const InputDecoration(hintText: "Timer"), 
                    ),
                  ],
              ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Type in here. Press enter to validate"
                ),
                //onChanged is called whenever we add or delete something on Text Field
                onSubmitted: (String str){
                  setState(() {
                    textrefresh = str;
                  });
                  _makePostRequest(str);
                }
              ),
              const SizedBox(height: 20),
              //displaying input text
              Text(result),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: indexwidg == optionSelected ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    logic.refresh();
                    setState(() {
                      optionSelected = indexwidg;
                    });
                  },
                  child: Text('Select widget :' + indexwidg.toString())
                ),
              ]
            )
        )
      )
    );
  }
  /// Function to request data to the node server on port 8080
  Future<http.Response> _makePostRequest(String city) async {
    /// Response from the node server
    final response = await /*return*/ http.post(
      Uri.parse('http://localhost:8080'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "Weather_hum " + city
    );
    if (response.statusCode == 200) {
      setState(() {
        result = response.body;
      });
    }
    return response;
  }
}