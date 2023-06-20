import 'dart:async';
import 'package:gsheets/gsheets.dart';

class GoogleSheetAPI {
  static const credential = r'''
  {
    "type": "service_account",
  "project_id": "awake-371404",
  "private_key_id": "4bc570000c462d6d610d81b4754bca8d8ecc2a0a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDdtiY4wQc0TEcx\npWtGx8tcd3l+nHprvzSt6ioL2jnHNKFgbbNWTFBtmCjdWaFdH/MI13OfINfCQvVt\nosgTED1IlyfqrVAI4ynRviXJSCOwRyisbL5pD9Apd94Wdm5TQ+oMcV1MNbRxt7iT\n2HsiR8yYnPnUOVz2AaYLJ/lW0L9R0G0pRuVfralyrYiaaw1BznWVpReK3MGiigsf\nrF/o3Kpe+pxAvSBKTk833Ut7uuZzrvKe2Qxn3f13lL9HPGfGPuHLCuZlnswPXwjc\nNxCA04DKtmvyLIdnRXTsAPUs0uMaYl+goWgEs68NQwPvU7BPnXXAhRqA3A3S8Ksd\nZzA5qTyDAgMBAAECggEACAQZbqzf906Ytl1OOyFnI2E4ddDvhizEGVOhkIsj0qV+\n/i8JMGIS+FtrgtFGSckpbtTnW8YCtwXXvM6JYFMSfCjm6w+4GJIqBWjUEep3S9zO\nxikqWz8UniM01ugSRhVrBWcl4ecBLqlfVY0aqpsg9RWb3MX0K/rUR4v68l4axLjs\ntmryrGVDzTj0oH+75qUkQygHfy4N96ppq5a97jojNmaq6BddpPA/diHp+V8yZXws\nlW8NPOUfhfam7J3ueBlWh9aF/NSJ1EP0QEZKWcyKaD9DINH3MUTMxg0XnrzpYHqN\nKQ99vMnxkFAkY/PpxF+ZWxMS/M1bqEF9WsweTRAKOQKBgQDy22LJqVvzXBUAMhF2\n/QiyFO9xEtocmc7iqydWTb5OTilO5MoDMS2MWm71lgEi/LXEvnOyiD0N80JUP3Dm\nXSTvDU6wlMNtUtVI3UNg0OP5hPo4mfptaxS++ArlMQpFf7rYX3Dy2O68h1RKTwpV\nSYdSMrajOSNuCsjcaauPQrkA6wKBgQDptc7QiJIwjXc4B/CHevMmfSqx2Cj7mqbP\nbieil+yPU4uHgrTbfDZFmxusddUDuotnSbhOltMu0Zr6lgt0qJhy23C1lqy71Xbz\nBRsNnjqX/MpCWmZ/11l9vALYvVVTLTfM38ZwR2htY/xewSbd/ayBXh1UBMDW7H62\nodrzG/WMyQKBgQC6+NydlZ4NRp+EfwejLDw9npCZ5YG281Osf0jR0RjrAJIdA1fk\nDUCcBiPXP52wag8nYdmBYhJfYyF160HomV2ODhi/KkkrKdK7Pl5Zc3mQ6Sgb27BJ\n/V8Dh8QboB3gU+5uF0zGKu3ih+4FJ8U01F8ykYi7MYptdjAeQdyrdxsn8QKBgQCn\nIL5+3cs9MUz6IqNdHw1WjtfDSkM0egmj+LAbU+11KVd0VoIjGxZsfFkz4SetfO9H\ns647dRwcNQRRAo+6ov4x1L8q/E8WG7buXs5T1L0uBzZUcPUvor56bcLTX8Husz1e\nIwBzNn11DLVixVmYEloUQUtT0/pbN8/9po0+oNXeEQKBgBOwkgBDpmeTKccduFIA\nJXwFt/IEpay3MAChLSOR8Ioh+4xKG0C7WqIwah0CsyQluOxbN5Qzx9DoKyVIiIiJ\nqmj3HN8NKxrWVLtNeXnaBfUDsJI5DQ2RkxMiqEvp5KM8yEx15vZIYFuDABIml+Xv\nXFZCPY4TjCVwSEeMSenoZy+D\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account-awake@awake-371404.iam.gserviceaccount.com",
  "client_id": "102808461899248209958",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/service-account-awake%40awake-371404.iam.gserviceaccount.com"
  }
  ''';

  static final spreadsheetID = '1tIxzMr8OjGyZGXY839kYm7-1rxwGIk_NWg13NdLb8F8';
  static final gsheets = GSheets(credential);
  static Worksheet? worksheet;
  static List<dynamic> currentScore = [];
  static bool loading = true;

  static Future init() async {
    final ss = await gsheets.spreadsheet(spreadsheetID);
    worksheet = ss.worksheetByTitle('worksheet1');
    await FetchScore();
  }

  static Future FetchScore() async {
    if (worksheet == null) return;
    final scoreP = await worksheet!.values.value(column: 4, row: 2);
    String wakeTime = await worksheet!.values.value(column: 5, row: 2);
    String sleepTime = await worksheet!.values.value(column: 6, row: 2);

    currentScore.isEmpty
        ? currentScore.add([scoreP, wakeTime, sleepTime])
        : currentScore[0] = [scoreP, wakeTime, sleepTime];
    print('we got it');
    print(currentScore);
    loading = false;
  }

  static double Score() {
    double Tscore = 25;
    if (currentScore.isNotEmpty) {
      Tscore = double.parse(currentScore[0][0]);
    }
    print('hai');
    print(Tscore);
    return Tscore;
  }

  double Wttt() {
    double ww = 25;
    if (currentScore.isNotEmpty) {
      ww = double.parse(currentScore[0][1]);
    }
    print('hai');
    print(ww);
    return ww;
  }

  double Sttt() {
    double tt = 25;
    if (currentScore.isNotEmpty) {
      tt = double.parse(currentScore[0][2]);
    }
    print('hai');
    print(tt);
    return tt;
  }

  Future<void> send(String sleepTime, String wakeUpTime) async {
    if (worksheet == null) {
      throw Exception('Worksheet cannot be null.');
    }

    await worksheet!.values
        .insertColumn(1, [DateTime.now().toString(), sleepTime]);
    await worksheet!.values
        .insertColumn(2, [DateTime.now().toString(), wakeUpTime]);
  }
}
