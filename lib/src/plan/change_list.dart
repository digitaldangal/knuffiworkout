import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:meta/meta.dart';

typedef Widget ItemToWidget<T>(BuildContext context, List<T> items, int index);

class ChangeList<T> extends StatefulWidget {
  final Stream<FireMap<T>> changes;
  final ItemToWidget<T> widgetBuilder;

  ChangeList({@required this.changes, @required this.widgetBuilder});

  @override
  _ChangeListState<T> createState() => new _ChangeListState<T>();
}

class _ChangeListState<T> extends State<ChangeList> {
  final _scrollController = new ScrollController();
  List<T> items;

  @override
  Widget build(BuildContext context) =>
      new StreamWidget1<FireMap<T>>(widget.changes, _rebuild);

  Widget _rebuild(FireMap<T> snapshot, BuildContext context) {
    final newItems = snapshot.values.toList();
    bool scrollToEnd = items != null && newItems.length > items.length;
    items = newItems;

    if (scrollToEnd) {
      _triggerScrollToEnd();
    }

    return new ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) =>
          widget.widgetBuilder(context, items, index),
      shrinkWrap: true,
      controller: _scrollController,
    );
  }

  Future _triggerScrollToEnd() async {
    await new Future.delayed(const Duration(milliseconds: 50));
    _scrollController.animateTo(999999.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
