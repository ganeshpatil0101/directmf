import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sink/models/mfData.dart';
import 'package:sink/models/parsedMf.dart';

const NAV_PRICE_OPEN_API = 'https://www.amfiindia.com/spages/NAVAll.txt';

class MfApiService {
  static Future<ParsedMf> getMfDetailsByMfId(mfId) async {
    final res = await http.get(NAV_PRICE_OPEN_API);
    return MfApiService._parseToMfData(res.body, mfId);
  }

  static Future<String> getAllMfNavPrice() async {
    final res = await http.get(NAV_PRICE_OPEN_API);
    return res.body.toString();
  }

  static _parseToMfData(String res, String mfId) {
    var data = res.toString();
    var arrData = data.split('\n');
    var parsedData = MfApiService.getLine(arrData, mfId);
    if (parsedData.length > 0) {
      var shortMfName = parsedData[3].split('-')[0];
      return ParsedMf(
        mfId: parsedData[1],
        name: shortMfName ?? parsedData[3],
        nav: double.parse(parsedData[4]),
      );
    }
    return false;
  }

  static getLine(List arrData, String mfId) {
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
