import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sink/models/mfData.dart';
import 'package:sink/models/parsedMf.dart';

class MfApiService {
  Future<ParsedMf> getMfDetailsByMfId(mfId) async {
    final res = await http.get('https://www.amfiindia.com/spages/NAVAll.txt');
    return this._parseToMfData(res.body, mfId);
  }

  _parseToMfData(String res, String mfId) {
    var data = res.toString();
    var arrData = data.split('\n');
    var parsedData = this.getLine(arrData, mfId);
    if (parsedData.length > 0) {
      return ParsedMf(
        mfId: parsedData[1],
        name: parsedData[3],
        nav: double.parse(parsedData[4]),
      );
    }
    return false;
  }

  getLine(List arrData, String mfId) {
    var d = [];
    var count = 0;
    // TODO improve login by removing for and use regex to get line number remove count
    for (final dt in arrData) {
      var indx = dt.indexOf(mfId);
      if (indx > -1) {
        d = arrData[count].split(';');
        break;
      }
      count++;
    }
    return d;
  }
}
