import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class MFData {
  // final String mfId;
  // final double amtInvstd;
  final String name;
  // final double units;
  // final double nav;
  // final double curValue;

  MFData({
    //  @required this.mfId,
    @required this.name,
    // @required this.amtInvstd,
    // @required this.units,
    // @required this.nav,
    // @required this.curValue,
  });

  static fromSnapshot(DocumentSnapshot document) {
    return MFData(
      //id: document['id'],
      name: document['name'],
    );
  }
}
