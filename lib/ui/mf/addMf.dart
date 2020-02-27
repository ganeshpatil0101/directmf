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
  final Function onSave;
  final MFData data;

  AddMfForm({@required this.onSave, @required this.data});
  @override
  AddFmFormState createState() => AddFmFormState(this.data);
}

class AddFmFormState extends State<AddMfForm> {
  String mfName, mfId, folioId;
  double amtInvstd, units, nav, curValue;
  bool showLoading = false;
  var curValController = TextEditingController(),
      mfIdController = TextEditingController(),
      mfNameCtrl = TextEditingController(),
      unitsCtrl = TextEditingController(),
      navCtrl = TextEditingController();

  final MFData data;
  AddFmFormState(this.data) {
    mfIdController.text = data.mfId;
    mfNameCtrl.text = data.name;
    curValController.text = data.curValue.toStringAsFixed(2);
    navCtrl.text = data.nav.toStringAsFixed(3);
    amtInvstd = data.amtInvstd;
    unitsCtrl.text = data.units.toStringAsFixed(2);
    folioId = data.folioId;
  }

  @override
  void initState() {
    navCtrl.addListener(() => updateCurrentValuation());

    unitsCtrl.addListener(() => updateCurrentValuation());
    super.initState();
  }

  void updateCurrentValuation() {
    if (unitsCtrl.text != "" && navCtrl.text != "") {
      double curVal = double.parse(unitsCtrl.text) * double.parse(navCtrl.text);
      curValController.text = curVal.toStringAsFixed(2);
    }
  }

  void handleNameChange(String newName) {
    setState(() {
      this.mfName = newName;
    });
  }

  void handleSave(
    Function(String, String, String, double, double, double, double) onSave,
    BuildContext context,
  ) {
    onSave(
        mfNameCtrl.text,
        folioId,
        mfIdController.text,
        amtInvstd,
        double.parse(unitsCtrl.text),
        double.parse(navCtrl.text),
        double.parse(curValController.text));
    Navigator.pop(context);
  }

  void searchMfById(mfId) async {
    setState(() {
      this.showLoading = true;
    });
    var res = MfApiService.getMfDetailsByMfId(mfId);
    res.then((res) {
      mfNameCtrl.text = res.name;
      navCtrl.text = res.nav.toStringAsFixed(2);
      setState(() {
        this.showLoading = false;
      });
    }).catchError((err) {
      print('====> $err');
      setState(() {
        this.showLoading = false;
      });
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: mfIdController,
                            decoration: InputDecoration(
                                hintText: "Enter 6 Digit ID & Search",
                                labelText: "MF ID",
                                border: OutlineInputBorder(),
                                //enabled:
                                //    (mfIdController.text != "") ? true : false,
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
                            onChange: (value) => {
                              setState(() {
                                this.folioId = value;
                              })
                            },
                            value: this.folioId,
                            style: Theme.of(context).textTheme.body1,
                            border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClearableNumberInput(
                            textCtrl: unitsCtrl,
                            onChange: (value) {},
                            value: this.units,
                            hintText: 'Total Units',
                            labelText: 'Total Units',
                            style: Theme.of(context).textTheme.body1,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClearableNumberInput(
                            textCtrl: navCtrl,
                            onChange: (value) {},
                            value: this.nav,
                            hintText: 'Current Nav Price',
                            labelText: 'Current Nav',
                            style: Theme.of(context).textTheme.body1,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: curValController,
                            enabled: false,
                            decoration: InputDecoration(
                                enabled: false, labelText: "Current Valuation"),
                          ),
                        ),
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
