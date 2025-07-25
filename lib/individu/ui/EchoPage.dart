import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/individu/presenter/EchoPresenter.dart';
import 'package:intl/intl.dart';

class EchoPage extends StatefulWidget {
  Bete ? _bete;
  EchographieModel ? _currentEcho;

  set currentEcho(EchographieModel value) {
    _currentEcho = value;
  }

  @override
  EchoPageState createState() => EchoPageState();

  EchoPage(this._bete);
  EchoPage.edit( this._currentEcho, this._bete, {Key ? key}) : super(key: key);
  EchoPage.modify( this._currentEcho, {Key ? key}) : super(key: key);
}

abstract class EchoContract extends GismoContract {
  EchographieModel ?  get currentEcho;
  Bete ? get bete;

  set currentEcho(EchographieModel? value);
}

class EchoPageState extends GismoStatePage<EchoPage>  implements EchoContract {
  EchoPageState();
  TextEditingController _dateEchoCtl = TextEditingController();
  TextEditingController _dateSaillieCtl = TextEditingController();
  TextEditingController _dateAgnelageCtl = TextEditingController();

  late EchoPresenter _presenter;
  int _nombre = 0;

  //final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(S.of(context).ultrasound),
        //leading: ( this.widget._bete == null) ? Text(""):Text(this.widget._bete!.numBoucle),
      ),
      body:
       Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            ( this.widget._bete == null) ? Container():Card.filled( child:  Center(child: Text(this.widget._bete!.numBoucle))),
            TextFormField(
                key: Key("dateEcho"),
                keyboardType: TextInputType.datetime,
                controller: _dateEchoCtl,
                decoration: InputDecoration(
                    labelText: S.of(context).date_ultrasound,
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).no_ultrasound_date;
                  }},
                onSaved: (value) {
                  setState(() {
                    _dateEchoCtl.text = value!;
                  });
                },
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime ? date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _dateEchoCtl.text = DateFormat.yMd().format(date);
                    });
                  }
                }),
            Text(
              S.of(context).result,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                Text(
                  S.of(context).empty,
                  style: new TextStyle(fontSize: 16.0),
                ),
                Radio(
                  value: 1,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                Text(
                  S.of(context).simple,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ]),
            Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                  value: 2,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  S.of(context).double,
                  style: new TextStyle(fontSize: 16.0),
                ),
                new Radio(
                  value: 3,
                  groupValue: _nombre,
                  onChanged: _handleRdNombreChange,
                ),
                new Text(
                  S.of(context).triplet,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            new TextFormField(
                key: Key("dateSaillie"),
                keyboardType: TextInputType.datetime,
                controller: _dateSaillieCtl,
                decoration: InputDecoration(
                    labelText: S.of(context).estimated_mating_date,
                    hintText: 'jj/mm/aaaa'),
                onSaved: (value) {
                  setState(() {
                    _dateSaillieCtl.text = value!;
                  });
                },
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100)) as DateTime;
                  if (date != null) {
                    setState(() {
                      _dateSaillieCtl.text = DateFormat.yMd().format(date);
                    });
                  }
                }),
            new TextFormField(
                key: Key("dateAgnelage"),
                keyboardType: TextInputType.datetime,
                controller: _dateAgnelageCtl,
                decoration: InputDecoration(
                    labelText: S.of(context).expected_lambing_date,
                    hintText: 'jj/mm/aaaa'),
                onSaved: (value) {
                  setState(() {
                    _dateAgnelageCtl.text = value!;
                  });
                },
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime ? date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _dateAgnelageCtl.text = DateFormat.yMd().format(date);
                    });
                  }
                }),

            (_isSaving) ? CircularProgressIndicator():
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (this.widget._currentEcho != null) ?
                      TextButton(
                        onPressed: () => _showDialog(context),
                        child: Text(S.of(context).bt_delete)):
                      Container(),
                    ElevatedButton(
                      child: Text(S.of(context).bt_save,),
                    //color: Colors.lightGreen[700],
                      onPressed: () => {this._presenter.saveEcho(_dateEchoCtl.text, _dateSaillieCtl.text, _dateAgnelageCtl.text , _nombre) })
                  ]),
          ]),

    );
  }

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton() {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: () {
        this._presenter.delete();
        Navigator.of(context).pop();
      },
    );
  }

  Future _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text(S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _continueButton(),
          ],
        );
      },
    );
  }
/*
  void _delete () async {
    if (this.widget._currentEcho != null) {
      var message  = await _bloc!.deleteEcho(this.widget._currentEcho!);
      Navigator.pop(context, message);
    }
    else
      Navigator.of(context).pop();
  }
*/
  @override
  void initState() {
    super.initState();
    this._presenter = EchoPresenter(this);
    if (this.widget._currentEcho == null)
      _dateEchoCtl.text = DateFormat.yMd().format(DateTime.now());
    else {
      _nombre = this.widget._currentEcho!.nombre;
      _dateEchoCtl.text = DateFormat.yMd().format(this.widget._currentEcho!.dateEcho);
      if (this.widget._currentEcho!.dateAgnelage != null)
        _dateAgnelageCtl.text = DateFormat.yMd().format(this.widget._currentEcho!.dateAgnelage!);
      if (this.widget._currentEcho!.dateSaillie != null)
      _dateSaillieCtl.text = DateFormat.yMd().format(this.widget._currentEcho!.dateSaillie!);
    }
   // _nec = this.widget._currentLevel;
  }

  void _handleRdNombreChange(int ? value) {
    setState(() {
      _nombre = value!;
    });
  }
/*
  void _saveEcho() async {
    String message;
    if (_nombre == null) {
      message = S.of(context).number_fetuses_empty;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    setState(() {
      _isSaving = true;
    });
    if (this.widget._currentEcho == null)
      this.widget._currentEcho = new EchographieModel();
    this.widget._currentEcho!.bete_id = this.widget._bete!.idBd!;
    this.widget._currentEcho!.dateEcho = DateFormat.yMd().parse(_dateEchoCtl.text);
    this.widget._currentEcho!.nombre = _nombre;
    if (_dateSaillieCtl.text.isNotEmpty)
      this.widget._currentEcho!.dateSaillie = DateFormat.yMd().parse(_dateSaillieCtl.text);
    else
      this.widget._currentEcho!.dateSaillie = null;
    if (_dateAgnelageCtl.text.isNotEmpty )
      this.widget._currentEcho!.dateAgnelage = DateFormat.yMd().parse(_dateAgnelageCtl.text);
    else
      this.widget._currentEcho!.dateAgnelage = null;
    message =
      await this._bloc!.saveEcho(this.widget._currentEcho!);
    ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }
*/

  @override
  EchographieModel ? get currentEcho {
    return this.widget._currentEcho;
  }

  @override
  set currentEcho(EchographieModel? value) {
    this.widget._currentEcho = value;
  }
  @override
  Bete? get bete {
    return this.widget._bete;
  }
}
