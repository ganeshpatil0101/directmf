import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:DirectMF/models/mfData.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:DirectMF/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:DirectMF/ui/mf/addMf.dart';

class EditMfPageArgs {
  final MFData editMfData;
  EditMfPageArgs(this.editMfData);
}

class AddEditMfPage extends StatelessWidget {
  static const route = '/addEditMfForm';
  @override
  Widget build(BuildContext context) {
    final EditMfPageArgs args = ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, _AddEditViewModel>(
      converter: _AddEditViewModel.fromState,
      builder: (context, vm) {
        return AddMfForm(
          onSave: vm.onSave,
          data: (args != null) ? args.editMfData : MFData.empty(),
        );
      },
    );
  }
}

class _AddEditViewModel {
  final Function(MFData) onSave;

  _AddEditViewModel({@required this.onSave});

  static _AddEditViewModel fromState(Store<AppState> store) {
    return _AddEditViewModel(
      onSave: (mfData) => store.dispatch(CreateMf(mfData)),
    );
  }
}
