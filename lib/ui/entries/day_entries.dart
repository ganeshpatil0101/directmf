import 'package:flutter/material.dart';
import 'package:DirectMF/models/entry.dart';
import 'package:DirectMF/ui/entries/entry_item.dart';
import 'package:DirectMF/ui/statistics/day_summary.dart';

class DayGroup extends StatelessWidget {
  final List<Entry> _entries;
  final DateTime _date;

  DayGroup(this._entries, this._date);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          DaySummaryTile(_date, _entries),
          Divider(height: 0.0),
          Column(
            children: _entries.map((entry) => EntryItem(entry)).toList(),
          ),
        ],
      ),
    );
  }
}
