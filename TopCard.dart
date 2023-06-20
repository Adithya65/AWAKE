import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  String score;
  String waketime;
  String sleeptime;

  TopCard(
      {required this.score, required this.waketime, required this.sleeptime});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('S L E E P   S C O R E'),
              Text(
                score + '%',
                style: TextStyle(fontSize: 45),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Waketime'),
                        Text(waketime + 'PM'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('SleepTime'),
                        Text(sleeptime + 'AM'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[350],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ]),
      ),
    );
  }
}
