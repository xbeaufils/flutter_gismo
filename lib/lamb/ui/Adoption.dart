

import 'package:flutter/material.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/model/AdoptionQualite.dart';

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
        title: Text(S.of(context).adoption_default_title),

      ),
      body:
      new Column(
          children: <Widget> [
            ListTile(
              title: Text(S.of(context).echelle_connasse),
              subtitle: Text(S.of(context).echelle_connasse_text),
              trailing: new Icon(Icons.copyright),
            ),
            _getAdoption(AdoptionEnum.level0),
            _getAdoption(AdoptionEnum.level1),
            _getAdoption(AdoptionEnum.level2),
            _getAdoption(AdoptionEnum.level3),
            _getAdoption(AdoptionEnum.level4),
            _getAdoption(AdoptionEnum.level5),
          ]),

    );
  }

  Widget _getAdoption(AdoptionEnum adoption) {
    AdoptionHelper translator = new AdoptionHelper(this.context);
    return RadioListTile<int>(
      title: Text(adoption.key.toString()),
      subtitle: Text(translator.translate(adoption)),
      value: adoption.key,
      groupValue: _adoption,
      onChanged: (int ? value) {
        setState(() {
          _adoption = value!;
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
    super.initState();
  }


}

