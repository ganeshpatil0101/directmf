import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class MFData {
  final String mfId;
  final String folioId;
  final double amtInvstd;
  final String name;
  final double units;
  final double nav;
  final double curValue;

  MFData({
    @required this.mfId,
    @required this.folioId,
    @required this.name,
    @required this.amtInvstd,
    @required this.units,
    @required this.nav,
    @required this.curValue,
  });

  static fromSnapshot(DocumentSnapshot document) {
    return MFData(
        //id: document['id'],
        name: document['name'],
        folioId: document['folioId'],
        mfId: document['mdId'],
        amtInvstd: document['amtInvstd'],
        units: document['units'],
        nav: document['nav'],
        curValue: document['curValue']);
  }
}
