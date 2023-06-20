import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GoogleSheets.dart'; // Import this package to format the time

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay _sleepTime = TimeOfDay.now(); // Initialize with the current time
  TimeOfDay _wakeUpTime = TimeOfDay.now(); // Initialize with the current time

  Future<void> _selectSleepTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _sleepTime,
    );
    if (newTime != null) {
      setState(() {
        _sleepTime = newTime;
      });
    }
  }

  Future<void> _selectWakeUpTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _wakeUpTime,
    );
    if (newTime != null) {
      setState(() {
        _wakeUpTime = newTime;
      });
    }
  }

  Future<void> _setAlarm() async {
    final sleepTime = DateFormat('hh:mm a')
        .format(DateTime(2023, 1, 1, _sleepTime.hour, _sleepTime.minute));
    final wakeUpTime = DateFormat('hh:mm a')
        .format(DateTime(2023, 1, 1, _wakeUpTime.hour, _wakeUpTime.minute));

    print('Sleep time: $sleepTime');
    print('Wake up time: $wakeUpTime');

    final gs = GoogleSheetAPI();
    await gs.send(sleepTime, wakeUpTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Alarm'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sleep Time:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '${DateFormat('hh:mm a').format(DateTime(2023, 1, 1, _sleepTime.hour, _sleepTime.minute))}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectSleepTime(context),
              child: Text('Select Sleep Time'),
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .grey, // Set the background color of the button to grey
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Wake Up Time:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '${DateFormat('hh:mm a').format(DateTime(2023, 1, 1, _wakeUpTime.hour, _wakeUpTime.minute))}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectWakeUpTime(context),
              child: Text('Select Wake Time'),
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .grey, // Set the background color of the button to grey
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _setAlarm,
              child: Text('Set'),
              style: ElevatedButton.styleFrom(
                primary: Colors
                    .blue, // Set the background color of the button to blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
