import 'package:flutter/material.dart';
import 'Chart.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Charts'),
      ),
      body: Column(children: [
        LineChartSample2(),
      ]),
    );
  }
}
