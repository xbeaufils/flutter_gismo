import 'package:flutter/material.dart';
import 'package:flutter_gismo/model/AgnelageQualite.dart';

class AgnelageDialog extends StatefulWidget {
  int _currentLevel;
  @override
  AgnelageState createState() => AgnelageState();

  AgnelageDialog(this._currentLevel);


}

class AgnelageState extends State<AgnelageDialog> {
  int _agnelage = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Defaut d'agnelage"),

      ),
      body:
      new Column(
          children: <Widget> [
            ListTile(
              title: const Text("Defauts courants sur l'agnelage"),
              subtitle: const Text("Permet d'évaluer les défauts sur l'agnelage"),
              trailing: new Icon(Icons.copyright),
            ),
            _getAgnelage(Agnelage.level0),
            _getAgnelage(Agnelage.level1),
            _getAgnelage(Agnelage.level2),
            _getAgnelage(Agnelage.level3),
            _getAgnelage(Agnelage.level4),
          ]),

    );
  }

  Widget _getAgnelage(Agnelage agnelage) {
    return RadioListTile<int>(
      title: Text(agnelage.key.toString()),
      subtitle: Text(agnelage.value),
      value: agnelage.key,
      groupValue: _agnelage,
      onChanged: (int ? value) {
        setState(() {
          _agnelage = value!;
          Navigator
              .of(context)
              .pop(_agnelage);
        });
      },
    );
  }

  @override
  void initState() {
    _agnelage = this.widget._currentLevel;
  }


}