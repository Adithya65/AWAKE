import 'package:flutter/material.dart';

class Arrhythmia extends StatefulWidget {
  @override
  _ArrhythmiaState createState() => _ArrhythmiaState();
}

class _ArrhythmiaState extends State<Arrhythmia> {
  int _activeClass = 1;
  bool presenceofar = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _activeClass = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _activeClass == 1 ? Colors.blue : Colors.transparent,
              ),
              child: Text(
                'Class 1',
                style: TextStyle(
                  color: _activeClass == 1 ? Colors.white : Colors.black,
                  fontWeight:
                      _activeClass == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeClass = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _activeClass == 2 ? Colors.blue : Colors.transparent,
              ),
              child: Text(
                'Class 2',
                style: TextStyle(
                  color: _activeClass == 2 ? Colors.white : Colors.black,
                  fontWeight:
                      _activeClass == 2 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _activeClass = 3;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _activeClass == 3 ? Colors.blue : Colors.transparent,
              ),
              child: Text(
                'Class 4',
                style: TextStyle(
                  color: _activeClass == 3 ? Colors.white : Colors.black,
                  fontWeight:
                      _activeClass == 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
