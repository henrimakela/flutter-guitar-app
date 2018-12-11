import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class HoursIn{
  final int hours;
  
  final charts.Color color;

  HoursIn(this.hours, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}