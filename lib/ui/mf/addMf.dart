import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/services/mf_api_service.dart';
import 'package:sink/ui/common/number_input.dart';
import 'package:sink/ui/common/progress_indicator.dart';
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
  bool showLoading = false;
  var curValController = TextEditingController();
  var mfIdController = TextEditingController();
  var mfNameCtrl = TextEditingController();
  var api = new MfApiService();

  void handleNameChange(String newName) {
    setState(() {
      this.mfName = newName;
    });
  }

  void handleSave(
    Function(String, String, String, double, double, double, double) onSave,
    BuildContext context,
  ) {
    print('handleSave Called');
    print(mfNameCtrl.text);
    onSave(mfNameCtrl.text, folioId, mfIdController.text, amtInvstd, units, nav,
        curValue);
    Navigator.pop(context);
  }

  void searchMfById(mfId) async {
    setState(() {
      this.showLoading = true;
    });
    var res = await api.getMfDetailsByMfId(mfId);
    print(res);
    mfNameCtrl.text = res.name;
    setState(() {
      this.showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final CategoryFormArgs args = ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state),
      builder: (BuildContext context, _ViewModel vm) {
        if (showLoading) {
          return PaddedCircularProgressIndicator();
        }

        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text('New Mutual Fund'),
              actions: <Widget>[
                IconButton(
                  disabledColor: Colors.grey,
                  iconSize: 28.0,
                  icon: Icon(Icons.check),
                  onPressed: !isBlank(mfIdController.text)
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
                    child: Column(
                      children: <Widget>[
                        /*Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: ClearableTextInput(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 15, 10, 15),
                              hintText: "Enter 6 Digit ID & Search",
                              labelText: "MF ID",
                              onChange: (value) =>
                                  {setState(() => this.mfId = value)},
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () => {print("Search MF By ID")},
                            ),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: mfIdController,
                            decoration: InputDecoration(
                                hintText: "Enter 6 Digit ID & Search",
                                labelText: "MF ID",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  disabledColor: Colors.transparent,
                                  onPressed: () =>
                                      {searchMfById(mfIdController.text)},
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClearableTextInput(
                            hintText: "Mutual Fund Name",
                            labelText: "MF Name",
                            textCtrl: mfNameCtrl,
                            onChange: (value) => handleNameChange(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClearableTextInput(
                            hintText: "Folio Number",
                            labelText: "Folio Number",
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
                            labelText: 'Amount Invested',
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
                            labelText: 'Total Units',
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
                                this.curValue = this.units * this.nav;
                                curValController.text =
                                    this.curValue.toStringAsFixed(2);
                              });
                            },
                            value: this.nav,
                            hintText: 'Current Nav Price',
                            labelText: 'Current Nav',
                            style: Theme.of(context).textTheme.body1,
                            //contentPadding: inputPadding,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          /*child: ClearableNumberInput(
                            onChange: (value) {
                              setState(() {
                                this.curValue = value;
                              });
                            },
                            enabled: false,
                            value: this.curValue,
                            hintText: 'Current Valuation',
                            labelText: 'Current Valuation',
                            style: Theme.of(context).textTheme.body1,
                            //contentPadding: inputPadding,
                            border: OutlineInputBorder(),
                          ),
                          */
                          child: TextFormField(
                            controller: curValController,
                            enabled: false,
                            decoration: InputDecoration(
                                enabled: false, labelText: "Current Valuation"),
                          ),
                          /*child: Text(
                            (this.curValue != null) ? this.curValue.toStringAsFixed(2) : "",
                            style: Theme.of(context).textTheme.body1,
                            semanticsLabel: "Current Value",
                          ),*/
                        )
                      ],
                    ),
                  ),
                ])));
      },
    );
  }
}

class _ViewModel {
  final Function(String, String, String, double, double, double, double) onSave;

  _ViewModel({
    @required this.onSave,
  });

  static _ViewModel fromState(
    Store<AppState> store,
  ) {
    return _ViewModel(
      onSave: (mfName, folioId, mfId, amtInvstd, units, nav, curValue) {
        print(
            "$mfId : $mfName : $folioId : $amtInvstd : $units : $nav : $curValue ");
        store.dispatch(
          CreateMf(
            MFData(
                name: mfName,
                folioId: folioId,
                mfId: mfId,
                amtInvstd: amtInvstd,
                units: units,
                nav: nav,
                curValue: curValue),
          ),
        );
      },
    );
  }
}
