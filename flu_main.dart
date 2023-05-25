import 'package:flutter/material.dart';
import 'icon.dart';
import 'LineChartSample2.dart';
import 'package:gsheets/gsheets.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "awake-371404",
  "private_key_id": "4bc570000c462d6d610d81b4754bca8d8ecc2a0a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDdtiY4wQc0TEcx\\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account-awake@awake-371404.iam.gserviceaccount.com",
  "client_id": "102808461899248209958",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/service-account-awake%40awake-371404.iam.gserviceaccount.com"
}
''';
const _spreadsheetId = '1tIxzMr8OjGyZGXY839kYm7-1rxwGIk_NWg13NdLb8F8';
void main() async {
  runApp(MyApp());
  // init GSheets
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);
  var sheet = ss.worksheetByTitle('worksheet1');
  //await sheet!.values.insertValue('first ', column: 2, row: 2);
  //await sheet!.values.insertValue('Secound', column: 2, row: 3);
  // Retrieve the values from the sheet
  //
  print('Red>>>>>>>>');
  print(await sheet!.values.value(column: 3, row: 2));
  print('IR>>>>>>>>');
  print(await sheet!.values.value(column: 4, row: 2));
  print('HR>>>>>>>>');
  print(await sheet!.values.value(column: 5, row: 2));
  print('HR_valid>>>>>>>>');
  print(await sheet!.values.value(column: 6, row: 2));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xff01354d),
      appBar: AppBar(
        title: Text(
          "Sleep Report",
          style:
              TextStyle(color: Color(0xfff97b05), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff01354d),
      ),
      body: Column(
        children: [
          icon(),
          Text(
            "Sleep Stage                               ",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 3,
                fontSize: 30,
                color: Color(0xfff97b05)),
          ),
          LineChartSample2(),
        ],
      ),
    ));
  }
}


