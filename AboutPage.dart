import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.grey, // Set appbar color to gray
      ),
      body: Center(
        child: Text(
          'Abhinand\nAdithya\nallen\nAthul',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
