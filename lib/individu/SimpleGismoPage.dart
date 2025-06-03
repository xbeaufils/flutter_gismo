import 'package:flutter/material.dart';

abstract class SimpleGismoPage {
  void back();
  void backWithMessage(String message);
}

class GismoStatePage<T extends StatefulWidget> extends  State<T> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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

}