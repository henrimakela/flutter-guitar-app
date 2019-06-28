import 'package:flutter/material.dart';


class OverView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OverViewState();
  }
}

class _OverViewState  extends State<OverView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: Text("Coming up", 
        style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}