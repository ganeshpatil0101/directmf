import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sink/common/calendar.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/models/parsedMf.dart';
import 'package:sink/main.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';

const NAV_PRICE_OPEN_API = 'https://www.amfiindia.com/spages/NAVAll.txt';
const UPLOAD_PDF_SERVER =
    'http://ec2-13-233-17-92.ap-south-1.compute.amazonaws.com:8000/upload';

class MfApiService {
  static Future<ParsedMf> getMfDetailsByMfId(mfId) async {
    DateTime lastSync = getLastNavSync(globalStore.state);
    if (isLastSynchPrev(lastSync)) {
      String allMfNavTxt = getAllMfNavTxt(globalStore.state);
      return MfApiService._parseToMfData(allMfNavTxt, mfId);
    } else {
      final res = await http.get(NAV_PRICE_OPEN_API);
      globalStore.dispatch(ReloadNavPrice(res.body));
      globalStore.dispatch(LastNavSync(DateTime.now()));
      return MfApiService._parseToMfData(res.body, mfId);
    }
  }

  static Future<String> getAllMfNavPrice() async {
    final res = await http.get(NAV_PRICE_OPEN_API);
    return res.body.toString();
  }

  static Future<String> upload_Pdf(filePath, filePass) async {
    try {
      var uri = Uri.parse(UPLOAD_PDF_SERVER);
      var request = new http.MultipartRequest("post", uri);
      request.fields['pass'] = filePass;
      request.files
          .add(await http.MultipartFile.fromPath('sampleFile', filePath));
      print(request);
      var response = await request.send();
      return response.stream.bytesToString();
    } catch (e) {
      throw e;
    }
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
    return throw "MF Id Not Found " + mfId;
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
