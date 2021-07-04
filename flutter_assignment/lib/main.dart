import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_assignment/pages/dashboard.dart';
import 'package:flutter_assignment/utils/util.dart';

// https://www.youtube.com/watch?v=-9JXRbpl4M8


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: Dashboard(),
      image: Image.asset(Util.LOGO),
      backgroundColor: Colors.white,
      photoSize: 125,
      loaderColor: Colors.white,
    );
  }
}
