import 'package:flutter/material.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';

abstract class GismoContract {
  void backWithObject(Object object);
  void back();
  void backWithMessage(String message, [bool error]);
  void showMessage(String message, [bool error]);
  void showSaving();
  Future<dynamic> goNextPage(StatefulWidget page);
}

class GismoStatePage<T extends StatefulWidget> extends  State<T> {
  bool _isSaving = false;

  bool get isSaving => _isSaving;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<dynamic> goNextPage(StatefulWidget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => page),
    );
  }

  void showMessage(String message, [bool error = false]) {
    ScaffoldMessenger.of(context).showSnackBar(this._buildSnackBar(message, error));
  }

  void backWithObject(Object object) {
    Navigator.of(context).pop( object);
  }

  void backWithMessage(String message, [bool error = false,]) {
    ScaffoldMessenger.of(context).showSnackBar(this._buildSnackBar(message, error))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }

  void back() {
    Navigator.of(context).pop();
  }

  SnackBar _buildSnackBar(String message, bool error ) {
    Widget ? content = null;
    Color ? backgroundColor = null;
    if (error) {
      content = Row(children: [Text(message,), Icon(Icons.error, color: sheepyGreenSheme.colorScheme.onError,)],mainAxisAlignment: MainAxisAlignment.spaceEvenly, );
      backgroundColor = sheepyGreenSheme.colorScheme.error;
    }
    else {
      content = Text(message);
      backgroundColor = sheepyGreenSheme.colorScheme.primary;
    }
    return SnackBar(
        key: Key("SnackBar"), 
        backgroundColor: backgroundColor,
        content: content);
  }
  

  void showSaving() {
    setState(() {
      _isSaving = true;
    });
  }

  void hideSaving() {
    setState(() {
      _isSaving = false;
    });
  }
}