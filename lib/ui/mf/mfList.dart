import 'package:flutter/material.dart';
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
          children: <Widget>[Text('Test Mf 1')],
        ),
      ),
    );
  }
}
