import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:DirectMF/models/mfData.dart';
import 'package:DirectMF/repository/firestore.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:redux/redux.dart';
import 'package:DirectMF/redux/selectors.dart';
import 'package:DirectMF/ui/common/progress_indicator.dart';
import 'package:DirectMF/ui/mf/mf_item.dart';

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
            var totalInvested = 0.0;
            var currentValuation = 0.0;
            var ch = snapshots.map((s) {
              MFData mf = MFData.fromSnapshot(s);
              totalInvested = totalInvested + mf.amtInvstd;
              currentValuation = currentValuation + mf.curValue;
              return MfItem(mf);
            });

            List<Widget> chw = [];
            chw.addAll(ch);
            var greenStyle = TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w500,
                color: Colors.green);
            var redStyle = TextStyle(
                fontSize: 21.0, fontWeight: FontWeight.w500, color: Colors.red);
            chw.insert(
                0,
                Container(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("Total Invested",
                                  style: Theme.of(context).textTheme.display1),
                              Text("Total Valuation",
                                  style: Theme.of(context).textTheme.display1),
                            ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(totalInvested.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.display1),
                              Text(
                                currentValuation.toStringAsFixed(2),
                                style: (currentValuation < 0)
                                    ? redStyle
                                    : greenStyle,
                              )
                            ]),
                      ]),
                ));

            return Scrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                children: chw, //TODO
                dragStartBehavior: DragStartBehavior.start,
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
