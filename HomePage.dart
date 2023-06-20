import 'dart:async';
import 'package:flutlab/GoogleSheets.dart';
import 'package:flutlab/Newpage.dart';
import 'package:flutlab/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'TopCard.dart';
import 'SnoringDataCard.dart';
import 'GoogleSheetrr.dart';
import 'SnoringData.dart';
import 'AboutPage.dart';
import 'AlarmScreen.dart';
import 'Chart.dart';
import 'SmartRoom/SmartHome.dart';
import 'arrhythmia.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  double _score = 0;
  double _wake = 0;
  double _sleep = 0;
  String _snoringData = "34";
  String _snoringTime = "0";
  String _snoringDuration = '0';

  @override
  void initState() {
    super.initState();
    _fetchScore();
  }

  Future<void> _refreshScreen() async {
    setState(() {
      _isLoading = true; // Set _isLoading to true before the API call
    });
    await GoogleSheetAPI.init();
    _score = GoogleSheetAPI.Score();
    _wake = GoogleSheetAPI().Wttt();
    _sleep = GoogleSheetAPI().Sttt();

    setState(() {
      _isLoading = false; // Set _isLoading to false after the API call
    });
  }

  Future<void> _fetchScore() async {
    print('are you ');
    await GoogleSheetAPI.init();
    setState(() {
      _isLoading = false;
      _score = GoogleSheetAPI.Score();
      _wake = GoogleSheetAPI().Wttt();
      _sleep = GoogleSheetAPI().Sttt();
    });
  }

  void _checkArrhythmia() {
    bool presenceofar = true;
    if (presenceofar) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Arrhythmia Detected'),
            content: Text('Please consult your doctor.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Awake'),
        actions: [
          IconButton(
            icon: Icon(Icons.report_problem),
            onPressed: _checkArrhythmia,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshScreen,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Settings"),
                value: "/settings",
              ),
              PopupMenuItem(
                child: Text("Help"),
                value: "/help",
              ),
            ],
            onSelected: (value) {
              if (value == "/settings") {
                Navigator.pushNamed(context, value.toString());
              } else if (value == "/help") {
                Navigator.pushNamed(context, value.toString());
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text('RoomControl'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SmartHomePage()),
                ); // TODO: Implement settings page navigation
              },
            ),
            ListTile(
              title: Text('Alarm'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmPage()),
                );
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[350],
      body: Column(
        children: [
          TopCard(
            score: _score.toString(),
            waketime: _wake.toString(),
            sleeptime: _sleep.toString(),
          ),
          SizedBox(
            height: 40,
          ),
          _isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: Container(
                    // remove the fixed height from the container
                    child: ListView(
                      children: [
                        SnoringDataCard(),

                        // Add more cards here...
                      ],
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        },
        child: Icon(Icons.arrow_circle_right),
      ),
    );
  }
}
