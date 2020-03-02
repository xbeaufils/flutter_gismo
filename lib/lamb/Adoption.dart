

import 'package:flutter/material.dart';
import 'package:flutter_gismo/model/AdoptionQualite.dart';

class AdoptionDialog extends StatefulWidget {
  int _currentLevel;
  @override
  AdoptionState createState() => AdoptionState();

  AdoptionDialog(this._currentLevel);

}

class AdoptionState extends State<AdoptionDialog> {
  int _adoption = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Défaut d'adoption"),

      ),
      body:
      new Column(
          children: <Widget> [
            ListTile(
              title: const Text("Echelle des connasses"),
              subtitle: const Text("Permet d'évaluer les qualités maternelles suivant les critères de Stéphanie Maubé"),
              trailing: new Icon(Icons.copyright),
            ),
            _getAdoption(Adoption.level0),
            _getAdoption(Adoption.level1),
            _getAdoption(Adoption.level2),
            _getAdoption(Adoption.level3),
            _getAdoption(Adoption.level4),
            _getAdoption(Adoption.level5),
          ]),

    );
  }

  Widget _getAdoption(Adoption adoption) {
    return RadioListTile<int>(
      title: Text(adoption.key.toString()),
      subtitle: Text(adoption.value),
      value: adoption.key,
      groupValue: _adoption,
      onChanged: (int value) {
        setState(() {
          _adoption = value;
          Navigator
              .of(context)
              .pop(_adoption);
        });
      },
    );
  }

  @override
  void initState() {
    _adoption = this.widget._currentLevel;
  }


}

