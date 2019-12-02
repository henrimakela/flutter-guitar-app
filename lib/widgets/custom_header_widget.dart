import 'package:flutter/material.dart';

class CustomHeaderWidget extends StatelessWidget {
  final backgroundColor;
  final double height;
  final FloatingActionButton fab;

  CustomHeaderWidget({this.backgroundColor, this.height, this.fab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(children: <Widget>[
        Positioned(bottom: 60, right: 30, child: fab),
      ]),
    );
  }
}
