import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:intl/intl.dart';


class MemoPage extends StatefulWidget {
  final GismoBloc _bloc;
  late Bete _bete;
  MemoModel ? _currentNote;

  @override
  MemoPageState createState() => MemoPageState(this._bloc);

  MemoPage(this._bloc,this._bete);
  MemoPage.edit(this._bloc, this._currentNote) ;
}

class MemoPageState extends State<MemoPage> {
  final GismoBloc _bloc;
  MemoPageState(this._bloc);

  TextEditingController _dateDebutCtl = TextEditingController();
  TextEditingController _dateFinCtl = TextEditingController();
  TextEditingController _noteCtl = TextEditingController();
  MemoClasse  _classe = MemoClasse.INFO;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(S.of(context).memo),
        //leading: Text(this.widget._bete.numBoucle),
      ),
      body:
        SingleChildScrollView ( child:
        new Column(
            children: <Widget> [
              new Card( child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Flexible( child:
                        new TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: _dateDebutCtl,
                          decoration: InputDecoration(
                              labelText: S.of(context).date_debut,
                              hintText: 'jj/mm/aaaa'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return S.of(context).no_date_debut;
                            }},
                          onSaved: (value) {
                            setState(() {
                              _dateDebutCtl.text = value!;
                            });
                          },
                          onTap: () async{
                            DateTime ? date = DateTime.now();
                            FocusScope.of(context).requestFocus(new FocusNode());
                            date = await showDatePicker(
                                //locale: const Locale("fr","FR"),
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              setState(() {
                                _dateDebutCtl.text = DateFormat.yMd().format(date!);
                              });
                            }
                          }),
                ),
                      new Flexible( child:
                      new TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: _dateFinCtl,
                          decoration: InputDecoration(
                              labelText: S.of(context).date_fin,
                              hintText: 'jj/mm/aaaa'),
                          onSaved: (value) {
                            setState(() {
                              _dateFinCtl.text = value!;
                            });
                          },
                          onTap: () async{
                            DateTime ? date = DateTime.now();
                            FocusScope.of(context).requestFocus(new FocusNode());
                            date = await showDatePicker(
                                //locale: const Locale("fr","FR"),
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              setState(() {
                                _dateFinCtl.text = DateFormat.yMd().format(date!);
                              });
                            }
                          }),
                      ),
              ])),
              Row(
                children: [
                  Radio(value: MemoClasse.ALERT, groupValue: _classe, onChanged: (MemoClasse ? value) {
                    setState(() {
                      _classe = value!;
                    });
                  }),
                  Icon(Icons.warning_amber_outlined),  Text( S.of(context).alert),Spacer(),
                  Radio(value: MemoClasse.WARNING, groupValue: _classe, onChanged: (MemoClasse ? value) {
                    setState(() {
                      _classe = value!;
                    });
                  }),
                  Icon(Icons.error_outline),  Text(S.of(context).warning),Spacer(),
                  Radio(value: MemoClasse.INFO, groupValue: _classe, onChanged: (MemoClasse ? value) {
                    setState(() {
                      _classe = value!;
                    });
                  }),
                  Icon(Icons.info_outlined),  Text(S.of(context).info),Spacer(),
                ],
              ),
              TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller: _noteCtl,
                  decoration: InputDecoration(
                      labelText: S.of(context).note_label,
                      hintText: S.of(context).note_hint),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return S.of(context).no_note;
                    }},
                  onSaved: (value) {
                    setState(() {
                      _noteCtl.text = value!;
                    });
                  }
              ),
              (_isSaving) ? CircularProgressIndicator():
              ElevatedButton(
                  child: Text(S.of(context).bt_save,),
                  //style: new TextStyle(color: Colors.white, ),),
                  style : ButtonStyle(
                    textStyle: MaterialStateProperty.all( TextStyle(color: Colors.white, ) ),
                    backgroundColor: MaterialStateProperty.all<Color>( (Colors.lightGreen[700])! ),),
                  //color: Colors.lightGreen[700],
                  onPressed: _saveNote)
            ]),

      )
    );
  }

  @override
  void initState() {
    super.initState();
    if (this.widget._currentNote == null)
      _dateDebutCtl.text = DateFormat.yMd().format(DateTime.now());
    else {
      _dateDebutCtl.text = DateFormat.yMd().format(this.widget._currentNote!.debut!);
      if (this.widget._currentNote!.fin != null)
        _dateFinCtl.text = DateFormat.yMd().format(this.widget._currentNote!.fin!);
      _noteCtl.text = this.widget._currentNote!.note!;
      this._classe = this.widget._currentNote!.classe!;
    }
  }

  void _saveNote() async {
    String message="";
    setState(() {
      _isSaving = true;
    });
    if (this.widget._currentNote == null)
      this.widget._currentNote = new MemoModel();
    this.widget._currentNote!.debut = DateFormat.yMd().parse(_dateDebutCtl.text);
    if (_dateFinCtl.text.isNotEmpty)
      this.widget._currentNote!.fin = DateFormat.yMd().parse(_dateFinCtl.text);
    else
      this.widget._currentNote!.fin = null;
    this.widget._currentNote!.note = _noteCtl.text;
    if (this.widget._currentNote!.bete_id == null)
      this.widget._currentNote!.bete_id = this.widget._bete.idBd;
    this.widget._currentNote!.classe = this._classe;
    //if (this.widget._bete != null)
    message = await this._bloc.saveNote(this.widget._currentNote!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)))
        .closed
        .then((e) => {Navigator.of(context).pop()});
  }

}
