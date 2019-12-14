import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sink/models/mfData.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:redux/redux.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/ui/categories/category.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
// import 'package:sink/models/category.dart';
// import 'package:sink/redux/selectors.dart';
// import 'package:sink/redux/state.dart';
// import 'package:sink/theme/icons.dart';

class MfList extends StatelessWidget {
  static const route = '/mflist';
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromState,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              centerTitle: true,
              title: Text('List Of MF'),
            ),
            body: Scrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  TypedCategoryList(type: "Mf List", mfList: vm.mfdata),
                ],
              ),
            ),
          );
        });
  }
}

class _ViewModel {
  List<MFData> mfdata;

  _ViewModel({@required this.mfdata});

  static _ViewModel fromState(Store<AppState> store) {
    List<MFData> mfData = [];
    getMfDataList(store.state).toList().forEach((c) => mfData.add(c));

    return _ViewModel(mfdata: mfData);
  }
}

class TypedCategoryList extends StatelessWidget {
  final String type;
  final List<Widget> mfList;

  TypedCategoryList._(this.type, this.mfList);

  factory TypedCategoryList({
    @required String type,
    @required List<MFData> mfList,
  }) {
    List<Widget> tiles = [TypedCategoryTitle(type)];
    tiles.addAll(mfList.map<Widget>((c) => CategoryTile(c)).toList());

    return TypedCategoryList._(type, tiles);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mfList,
    );
  }
}

class TypedCategoryTitle extends StatelessWidget {
  final String type;

  TypedCategoryTitle(this.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(this.type, style: Theme.of(context).textTheme.subhead),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final MFData md;

  CategoryTile(this.md);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CategoryIcon(
        iconData: icons[''],
        color: Color.fromRGBO(123, 345, 234, 1),
        isActive: true,
      ),
      title: Text(md.name),
    );
  }
}
