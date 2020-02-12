import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MfItemDetails extends StatelessWidget {
  final double nav;
  final double curValue;
  final double amtInvstd;
  MfItemDetails(this.nav, this.curValue, this.amtInvstd);

  @override
  Widget build(BuildContext context) {
    var actualStyle = Theme.of(context).textTheme.body1;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Nav", style: actualStyle),
              Text("Invested", style: actualStyle),
              Text("Current Value", style: actualStyle),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("${nav.toStringAsFixed(2)}", style: actualStyle),
              Text("${amtInvstd.toStringAsFixed(2)}", style: actualStyle),
              Text("${curValue.toStringAsFixed(2)}", style: actualStyle),
            ],
          ),
        ],
      ),
    );
  }
}
