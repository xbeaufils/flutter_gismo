import 'package:flutter/material.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/model/AgnelageQualite.dart';

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
        title: Text(S.of(context).lambing_default),

      ),
      body:
      new Column(
          children: <Widget> [
            ListTile(
              title: Text(S.of(context).title_lambing_default),
              subtitle: Text(S.of(context).text_lambing_default),
              trailing: new Icon(Icons.copyright),
            ),
            _getAgnelage(AgnelageEnum.level0),
            _getAgnelage(AgnelageEnum.level1),
            _getAgnelage(AgnelageEnum.level2),
            _getAgnelage(AgnelageEnum.level3),
            _getAgnelage(AgnelageEnum.level4),
          ]),

    );
  }

  Widget _getAgnelage(AgnelageEnum agnelage) {
    AgnelageHelper translator = new AgnelageHelper(this.context);
    return RadioListTile<int>(
      title: Text(agnelage.key.toString()),
      subtitle: Text(translator.translate(agnelage)),
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
    super.initState();
  }


}