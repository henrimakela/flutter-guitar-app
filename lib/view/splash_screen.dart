import 'package:flutter/material.dart';
import 'package:monthly_music_challenge/consts.dart';
import 'package:monthly_music_challenge/view/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainWidget()),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Consts.greenColor.withOpacity(0.5), BlendMode.lighten),
                image: AssetImage(
                  "assets/images/splash_screen_bg.jpeg",
                ),fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 250,
                height: 250,
                child: Image.asset(
                  "assets/images/app_logo_centered.png",
                )),
            Container(
              margin: EdgeInsets.fromLTRB(40, 0,40,0),
                child: Text(
              "Like a to-do app but for guitar exercises",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}
