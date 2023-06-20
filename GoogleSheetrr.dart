import 'dart:async';
import 'package:gsheets/gsheets.dart';

class GoogleSheetAPI2 {
  static const credential2 = r'''
  {
   "type": "service_account",
  "project_id": "awake-378606",
  "private_key_id": "b74d85534598a0de150e9a50239fbab0ea51aebc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDcPNyDtLlFbCMl\nCB1jbX2LB6bHpaGMqnzvsuVcIkVj4BZW5mXkJvEytziA+eItEFfEFhjKytEy9EaC\n2Yo91UAfdANStih6J9toYnb8X7lygjO9OnZZ423Rq/ctBNC+M9PSOWpBJlbiao4Q\nVpnmKmueqyBLAf9j5e5/vX/XR+km19J2EP1Qum7Ne7ASsFTaI/nbKpVMA0PV2WsJ\nsNuhlozrW0Kbnkwi9pg4Vrv7h+BwHcEJ+D4MVJwSTpG5UPS7sMBlHbbpvpcOr/vz\nX7XLHPLHvYDZI3wwzXgRS/7j3SfkJQP1v4dlJb27hQEwip0ox3Hk1ybIs3Cj9Pkq\nq/kax6XrAgMBAAECggEAVIG574OaD6xVs/DwLeWmZYGTGkpQucP1Wphfb8HqtE8Y\n41FWyXuz000AjmTTx4zc0G3WJ4I5UX7vy2ejpuQ7zZXbbJJe57iBdQVLOL2WT/zr\n03EqVoVw7yI4HvsZCdKjNag4QDVw40IVruk79lhSoThylLV4hKGGqVdSRY3fRbqV\n8RttF8FKuYHLNGJ6W9JhR+USCed3tyu4wcXsJonS+wrwvYziQCu7kibFWJCKcrHO\nwoj5DgeEggCoom5v510pDYo6jWj524v3CtZOKO1IO8ZyL0zmC7KXf+//w97ryowO\nmDJVMG1jocL+kCvxjH4oINpksaoyx5kJKXNShPGbQQKBgQD+AWFRBlHvQaVFXBsl\nHjLVnuLm3QrJN8u9E1GpoQs7msNMsTR38/X1uDzchPi/Bn7TIGXEkJTLPDgfkAks\ns31oC0SK0z7nlFeA6wNlpDnuoPIUajtgH8kXG0jpIoic+2ZbsUUXLO10qO3woGp+\n1LqKmsmEC0zZHYGeq0/A2Mk1YQKBgQDd95ldxPaG07wQOvVXK0EYZ0HJqmWqM/tq\nx1KQAtMnUrY9EeK4VIbSY5KlIKPOZry7b45DnsiTTV3fngFSOr6LS6JM4b1qRJtB\nnmG9ODV5RgKcSutFqqjTpSLMlOhFI8+89g0cIlOg8jDFdl/uMTJUW/RvLUV7RwKE\n7v2gTmmSywKBgQDS+Q59oAQ594pwe7pIMDcE272XB43H58Ifv4YaoJqV3UvNzXnJ\nECcA+xACEagR8jEw5z3f8D7GN7Rd8uLL8CF/Y6yAqkkbTEkJ2SmvKKK9o4yujDXY\n902tFYqPqZFS4jT4f9rlDvoD5bQMIxGRWtu9+CbcuA4SX8GjqqLJiMZGwQKBgQDS\nHqwBFw3kLhWOK7HKFbkmd8DQPczFpTWwLAWdK/9k7yhygTblFacXDIlqZY6LObgZ\nmw3KN0paHtfpcnJ/u/padHusWdlr+owaPur5K3d7WOnpuAYlydrNlzps/d0ubise\nDrH0Ww5dgkbm9hrzqYCiWPX4NJvciij5XB+dm/zWpwKBgHE1J/o8nFmFXCVFbWm1\nS2sQ/rYSjE/TwypAXUGXX8bwfCqre4mQex8P0PGE/rYGHYR9FV3uMMI4HTJBo7PN\n7qThkON4sLWNJy9tvEEa8rYCfbxdfBEFTbUCmIZySY4SmNAQmgDxCx9u78NYCk9+\n1UnocURJlXMijqJiyF6oNTrK\n-----END PRIVATE KEY-----\n",
  "client_email": "awakest@awake-378606.iam.gserviceaccount.com",
  "client_id": "101950352325914770089",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/awakest%40awake-378606.iam.gserviceaccount.com"
  }
  ''';

  static final spreadsheetID2 = '1r1XiwoRsqTDhNKvtgH3vPm17N8IBfdT7AtwtS1W0SK0';
  static final gsheets2 = GSheets(credential2);
  static Worksheet? worksheet2;
  static List<dynamic> currentScore2 = [];
  static bool loading2 = true;

  static Future init2() async {
    final ss = await gsheets2.spreadsheet(spreadsheetID2);
    worksheet2 = ss.worksheetByTitle('Sheet1');
    await FetchScore2();
  }

  static Future FetchScore2() async {
    if (worksheet2 == null) return;
    final scoreP2 = await worksheet2!.values.value(column: 12, row: 1);
    final wakeTime2 = await worksheet2!.values.value(column: 12, row: 2);
    final sleepTime2 = await worksheet2!.values.value(column: 6, row: 2);
    currentScore2.isEmpty
        ? currentScore2.add([scoreP2, wakeTime2, sleepTime2])
        : currentScore2[0] = [scoreP2, wakeTime2, sleepTime2];
    print('New Boy');
    print(currentScore2);
    loading2 = false;
  }

  static double Score2() {
    double Tscore2 = 25;
    if (currentScore2.isNotEmpty) {
      Tscore2 = double.parse(currentScore2[0][0]);
    }
    print('Ney Boy hai');
    print(Tscore2);
    return Tscore2;
  }

  double Wttt2() {
    double ww2 = 25;
    if (currentScore2.isNotEmpty) {
      ww2 = double.parse(currentScore2[0][1]);
    }
    print('helllloppppp');
    print(ww2);
    return ww2;
  }

  double Sttt2() {
    double tt2 = 25;
    if (currentScore2.isNotEmpty) {
      tt2 = double.parse(currentScore2[0][2]);
    }
    print('bbbbbbbbbbbbbbb');
    print(tt2);
    return tt2;
  }
}
