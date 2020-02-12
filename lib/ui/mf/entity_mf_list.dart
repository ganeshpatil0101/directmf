import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/redux/state.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/entries/day_entries.dart';
import 'package:sink/ui/mf/mfList.dart';
import 'package:sink/ui/mf/mf_item.dart';
import 'package:sink/ui/statistics/balance.dart';

import 'package:sink/theme/palette.dart' as Palette;

class EntityMfList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return StreamBuilder<QuerySnapshot>(
          stream: vm.database.getMfEntiresSnapshot(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return PaddedCircularProgressIndicator();
            }
            List<DocumentSnapshot> snapshots = snapshot.data.documents;
            var ch = snapshots.map((s) {
              MFData mf = MFData.fromSnapshot(s);
              print(mf.name);
              return MfItem(mf);
            });
            List<Widget> chw = [];
            chw.addAll(ch);
            print(ch);

            return Scrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                children: ListTile.divideTiles(context: context, tiles: chw)
                    .toList(), //TODO
              ),
            );
          },
        );
      },
    );
  }
}

class _ViewModel {
  final FirestoreDatabase database;

  _ViewModel({@required this.database});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(database: getRepository(store.state));
  }
}