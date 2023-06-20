import 'package:flutter/material.dart';
import 'arrhythmia.dart';

class Body extends StatelessWidget {
  bool presenceofar = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Arrhythmia(),
      ],
    );
  }
}
