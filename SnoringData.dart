import 'package:flutter/material.dart';
import 'GoogleSheetrr.dart';
import 'package:intl/intl.dart';

class SnoringData extends StatefulWidget {
  const SnoringData({Key? key}) : super(key: key);
  _SnoringDataState createState() => _SnoringDataState();
}

String _snoringTime = 'hai';
String _snoringDuration = "Hello";
bool _Loading = true;
String formattedSnoringDuration = 'asd';
String formattedSnoringTime = 'fsdf';

class _SnoringDataState extends State<SnoringData> {
  void initState() {
    super.initState();
    fetchScore2();
  }

  Future<void> fetchScore2() async {
    setState(() {
      _Loading = true;
    });

    try {
      await GoogleSheetAPI2.init2();
      setState(() {
        _snoringTime = GoogleSheetAPI2.Score2().toString();
        _snoringDuration = GoogleSheetAPI2().Wttt2().toString();
        _Loading = false;
      });
    } catch (error) {
      print('Error fetching data from Google Sheet: $error');
      setState(() {
        _Loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Loading
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Snoring Time: $_snoringTime',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Snoring Duration: $_snoringDuration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ),
              ], // end of Column children list
            ),
          );
  }
}
