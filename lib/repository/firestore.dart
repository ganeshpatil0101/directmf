import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DirectMF/models/category.dart';
import 'package:DirectMF/models/entry.dart';
import 'package:DirectMF/models/mfData.dart';

const String LAST_NAV_SYNC = "lastNavSync";

class FirestoreDatabase {
  static Firestore _db = Firestore.instance;

  final String userId;
  final CollectionReference entries;
  final CollectionReference categories;
  final CollectionReference mfdatacollection;
  final CollectionReference lastNavCol;

  FirestoreDatabase._()
      // For testing only
      : this.userId = '',
        this.entries = null,
        this.categories = null,
        this.lastNavCol = null,
        this.mfdatacollection = null;

  FirestoreDatabase(this.userId)
      : this.entries =
            _db.collection("users").document(userId).collection("entry"),
        this.categories =
            _db.collection("users").document(userId).collection("category"),
        this.lastNavCol =
            _db.collection("users").document(userId).collection(LAST_NAV_SYNC),
        this.mfdatacollection =
            _db.collection("users").document(userId).collection("mfData");

  Stream<QuerySnapshot> getEntriesSnapshot() {
    return entries.orderBy('date', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getFirstEntry() {
    return entries.orderBy('date', descending: false).limit(1).snapshots();
  }

  Stream<QuerySnapshot> getMfEntiresSnapshot() {
    return mfdatacollection.orderBy('name', descending: true).snapshots();
  }

  Stream<QuerySnapshot> snapshotBetween(DateTime from, DateTime to) {
    return entries
        .where('date', isGreaterThanOrEqualTo: from, isLessThanOrEqualTo: to)
        .snapshots();
  }

  void create(Entry entry) {
    entries.reference().document(entry.id).setData(entry.toMap());
  }

  void delete(Entry entry) {
    entries.reference().document(entry.id).delete();
  }

  Future<QuerySnapshot> getCategories() async {
    return categories.orderBy('name', descending: false).getDocuments();
  }

  Future<QuerySnapshot> getMfDataList() async {
    return mfdatacollection.getDocuments();
  }

  void createCategory(Category category) {
    categories.reference().document(category.id).setData({
      'id': category.id,
      'name': category.name,
      'icon': category.icon,
      'color': category.color.value,
      'type': category.type.index,
    });
  }

  void createMf(MFData mf) {
    mfdatacollection.reference().document(mf.mfId).setData({
      'name': mf.name,
      'folioId': mf.folioId,
      'mfId': mf.mfId,
      'amtInvstd': mf.amtInvstd,
      'units': mf.units,
      'nav': mf.nav,
      'curValue': mf.curValue
    });
  }

  Future<void> updateLastNavSync(DateTime today) {
    return lastNavCol
        .reference()
        .document(LAST_NAV_SYNC)
        .setData({'date': today});
  }
}

class TestFirestoreDatabase extends FirestoreDatabase {
  String userId;

  TestFirestoreDatabase() : super._();
}
