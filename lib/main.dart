import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import './view/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "newsHub",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // No need of streamsubscription
  ConnectivityResult previous;

  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // internet conn available
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
        } else {
          // no conn
          _showdialog();
        }
      }).catchError((error) {
        // no conn
        _showdialog();
      });
    } on SocketException catch (_) {
      // no internet
      _showdialog();
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
      } else if (previous == ConnectivityResult.none) {
        // internet conn
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
      }

      previous = connresult;
    });
  }

  void _showdialog() {
    showDialog(
      context: context,
      builder: (context) => Card(
        // color: Colors.green,

        // color: Colors.green,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Text(
                'No Internet Detected.',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              height: 200,
              // color: Colors.green,
              child: Center(child: Image.asset('assets/images/help.gif')),
            ),
            SizedBox(
              height: 40,
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              // method to exit application programitacally
              onPressed: () => SystemNavigator.pop(),
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.scale(
              scale: 0.5,
              child: Container(
                child: Center(child: Image.asset('assets/images/newshub.png')),
              ),
            ),
            Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
            //Padding(
            //padding: EdgeInsets.only(top: 20.0),
            //child: Text("Checking Your Internet Connection."),
            //),
          ],
        ),
      ),
    );
  }
}
