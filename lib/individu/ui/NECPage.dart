import 'package:flutter/material.dart';
import 'package:gismo/bloc/GismoBloc.dart';
import 'package:gismo/core/ui/NumBoucle.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/NECModel.dart';
import 'package:gismo/individu/presenter/NECPresenter.dart';
import 'package:intl/intl.dart';

class NECPage extends StatefulWidget {
  Bete _bete;

  @override
  NECPageState createState() => NECPageState();

  NECPage(this._bete);
}

abstract class NECContract extends GismoContract {
  Bete get bete;
}

class NECPageState extends GismoStatePage<NECPage> implements NECContract {
  NECPageState();
  late NECPresenter _presenter;
  int _nec = 0;
  TextEditingController _dateNoteCtl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(S.of(context).body_cond),
      ),
      body:
          Column (children: [
            NumBoucleView(this.widget._bete),
          Card(child:
            Column(
              children: <Widget> [
                TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: _dateNoteCtl,
                    decoration: InputDecoration(
                        labelText: S.of(context).dateDeNotation,
                        hintText: 'jj/mm/aaaa'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Pas de date de notation";
                      }},
                    onSaved: (value) {
                      setState(() {
                        _dateNoteCtl.text = value!;
                      });
                    },
                    onTap: () async{
                      DateTime ? date = DateTime.now();
                      FocusScope.of(context).requestFocus(new FocusNode());
                      date = await showDatePicker(
                          locale: const Locale("fr","FR"),
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        setState(() {
                          _dateNoteCtl.text =  DateFormat.yMd().format(date!);
                        });
                      }
                    }),
                _getNec(NEC.level0),
                _getNec(NEC.level1),
                _getNec(NEC.level2),
                _getNec(NEC.level3),
                _getNec(NEC.level4),
                _getNec(NEC.level5),
                (_isSaving) ? CircularProgressIndicator():
                  FilledButton(
                    child: Text(S.of(context).bt_save,),
                    onPressed: () => this._presenter.saveNote(_dateNoteCtl.text, _nec) )
              ]),

      )]));
  }

  Widget _getNec(NEC nec) {
    return RadioListTile<int>(
      title: Text(nec.note.toString()),
      subtitle: Text(nec.label),
      secondary: IconButton(
        icon: new Icon(Icons.help),
        onPressed: () =>{
          Navigator.push(context,MaterialPageRoute(builder: (context) => HelpPage( nec),),)},),
      value: nec.note,
      groupValue: _nec,
      onChanged: (int ? value) {
        setState(() {
          _nec = value!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this._presenter = NECPresenter(this);
    _dateNoteCtl.text = DateFormat.yMd().format(DateTime.now());
   // _nec = this.widget._currentLevel;
  }

/*  void _saveNote() async {
    setState(() {
      _isSaving = true;
    });
    String message = await this._bloc.saveNec(this.widget._bete,  NEC.getNEC(_nec), DateFormat.yMd().parse(_dateNoteCtl.text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(key: Key("SaveNoteMessage"), content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }
 */
  Bete get bete => this.widget._bete;
}

class HelpPage  extends StatefulWidget {

  NEC _nec;

  HelpPage(this._nec);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: Text(S.of(context).body_cond),
    ),
    body:
      Card(
        child: ListTile(
          leading: Text(this.widget._nec.note.toString()),
          title: (Text(this.widget._nec.label)),
          subtitle: Text(this.widget._nec.description),
        ),)
    );
  }
}