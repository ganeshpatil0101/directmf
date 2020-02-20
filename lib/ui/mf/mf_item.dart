import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/ui/common/amount.dart';
import 'package:sink/ui/mf/addEditMfPage.dart';
import 'package:sink/ui/mf/mf_item_details.dart';

class MfItem extends StatelessWidget {
  final Key key;
  final MFData mf;

  MfItem(this.mf) : key = ObjectKey(mf);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state, mf.mfId),
      builder: (context, vm) {
        return Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              /*Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: ICON_BACKGROUND_SIZE,
                    height: ICON_BACKGROUND_SIZE,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vm.category.color,
                      ),
                      child: Icon(
                        icons[vm.category.icon],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),*/
              Flexible(
                child: ListTile(
                    title: Text(mf.name),
                    subtitle:
                        Text("Invested = ${mf.amtInvstd.toStringAsFixed(2)}"),
                    //subtitle: MfItemDetails(mf.nav, mf.curValue, mf.amtInvstd),
                    trailing: VisualizedAmount(
                      amount: mf.curValue - mf.amtInvstd,
                      income: (mf.curValue - mf.amtInvstd < 0) ? false : true,
                    ),
                    onTap: () => {
                          Navigator.pushNamed(context, AddEditMfPage.route,
                              arguments: EditMfPageArgs(mf)),
                        }),
              ),
            ],
          ),
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  final Function(Entry) onDismissed;
  final Function onUndo;

  _ViewModel({
    @required this.onDismissed,
    @required this.onUndo,
  });

  static _ViewModel fromState(Store<AppState> store, String mfId) {
    return _ViewModel(
      onDismissed: (entry) => {},
      onUndo: () => {},
    );
  }
}
