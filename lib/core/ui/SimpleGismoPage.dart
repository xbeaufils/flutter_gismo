import 'package:flutter/material.dart';

abstract class GismoContract {
  void back();
  void               backWithMessage(String message);
  void showMessage(String message);
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

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key("SnackBar"),
        content: Text(message)));
  }

  void backWithMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }

  void back() {
    Navigator.of(context).pop();
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