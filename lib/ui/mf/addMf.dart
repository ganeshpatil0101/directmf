import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/number_input.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/color_grid.dart';
import 'package:uuid/uuid.dart';

// class CategoryFormArgs {
//   final CategoryType type;

//   CategoryFormArgs(this.type);
// }

class AddMfForm extends StatefulWidget {
  static const route = '/addMfForm';

  @override
  AddFmFormState createState() => AddFmFormState();
}

class AddFmFormState extends State<AddMfForm> {
  String mfName, mfId, folioId;
  double amtInvstd, units, nav, curValue;
  void handleNameChange(String newName) {
    setState(() {
      this.mfName = newName;
    });
  }

  void handleSave(
    Function(String) onSave,
    BuildContext context,
  ) {
    print('handleSave Called');
    print(mfName);
    onSave(mfName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //final CategoryFormArgs args = ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state),
      builder: (BuildContext context, _ViewModel vm) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text('New Mutual Fund'),
              actions: <Widget>[
                IconButton(
                  disabledColor: Colors.grey,
                  iconSize: 28.0,
                  icon: Icon(Icons.check),
                  onPressed: !isBlank(mfName)
                      ? () => handleSave(vm.onSave, context)
                      : null,
                ),
              ],
            ),
            body: Scrollbar(
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8.0),
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableTextInput(
                              hintText: "Mf Name",
                              onChange: (value) => handleNameChange(value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableTextInput(
                              hintText: "Mf Id",
                              onChange: (value) =>
                                  {setState(() => this.mfId = value)},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableTextInput(
                              hintText: "Folio Number",
                              onChange: (value) =>
                                  {setState(() => this.folioId = value)},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableNumberInput(
                              onChange: (value) {
                                setState(() {
                                  this.amtInvstd = value;
                                });
                              },
                              value: this.amtInvstd,
                              hintText: 'Amount Invested',
                              style: Theme.of(context).textTheme.body1,
                              //contentPadding: inputPadding,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableNumberInput(
                              onChange: (value) {
                                setState(() {
                                  this.units = value;
                                });
                              },
                              value: this.units,
                              hintText: 'Total Units',
                              style: Theme.of(context).textTheme.body1,
                              //contentPadding: inputPadding,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableNumberInput(
                              onChange: (value) {
                                setState(() {
                                  this.nav = value;
                                  this.curValue = this.amtInvstd * this.nav;
                                });
                              },
                              value: this.nav,
                              hintText: 'Current Nav',
                              style: Theme.of(context).textTheme.body1,
                              //contentPadding: inputPadding,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClearableNumberInput(
                              onChange: (value) {
                                setState(() {
                                  this.curValue = value;
                                });
                              },
                              value: this.curValue,
                              hintText: 'Current Valuation',
                              style: Theme.of(context).textTheme.body1,
                              //contentPadding: inputPadding,
                              border: OutlineInputBorder(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ])));
      },
    );
  }
}

class _ViewModel {
  final Function(String) onSave;

  _ViewModel({
    @required this.onSave,
  });

  static _ViewModel fromState(
    Store<AppState> store,
  ) {
    return _ViewModel(
      onSave: (mfName) {
        store.dispatch(
          CreateMf(
            MFData(
              name: mfName,
            ),
          ),
        );
      },
    );
  }
}
