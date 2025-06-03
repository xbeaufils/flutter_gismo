import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/presenter/PeseePresenter.dart';
import 'package:intl/intl.dart';

class PeseePage extends StatefulWidget {
  final Bete ? _bete;

  final LambModel ? _lamb;

  @override
  PeseePageState createState() => PeseePageState();

  PeseePage(this._bete, this._lamb);

}

abstract class PeseeContract {
  Bete ? get bete;
  LambModel ? get lamb;
  void showSaving ();
  void showMessage(String message);
  void showErrorWeighing();
  void backWithMessage(String message);
}

class PeseePageState extends GismoStatePage<PeseePage> implements PeseeContract {
  late PeseePresenter _presenter;
  PeseePageState();
  //double _pesee = 0.0;
  TextEditingController _datePeseeCtl = TextEditingController();
  TextEditingController _poidsCtl = TextEditingController();
  //final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(S.of(context).weighing),
        //leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _datePeseeCtl,
                decoration: InputDecoration(
                    labelText: S.of(context).weighing_date),
                    //hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).no_weighing_date;
                  }},
                onSaved: (value) {
                  setState(() {
                    _datePeseeCtl.text = value!;
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
                      _datePeseeCtl.text =  DateFormat.yMd().format(date!);
                    });
                  }
                }),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: _poidsCtl,
              decoration: InputDecoration(
                  labelText: S.of(context).weight,
                  hintText: S.of(context).weighing_hint),
                validator: (value) {
                  if (value!.isEmpty) {
                    return S.of(context).no_weight_entered;
                  }},
                onSaved: (value) {
                  setState(() {
                    _poidsCtl.text = value!;
                  });
                }
            ),
            (_isSaving) ? CircularProgressIndicator():
              ElevatedButton(
                child: Text(S.of(context).bt_save,
                  style: new TextStyle(color: Colors.white, ),),
                //color: Colors.lightGreen[700],
                onPressed:() => { this._presenter.savePesee(_datePeseeCtl.text, _poidsCtl.text)})
          ]),

    );
  }

  @override
  void initState() {
    _presenter = PeseePresenter(this);
    super.initState();
    _datePeseeCtl.text = DateFormat.yMd().format(DateTime.now());
  }
/*
  void _savePesee() async {
    double? poids = double.tryParse(_poidsCtl.text);
    String message="";
    if (poids == null) {
      message = "";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).weighing_error)));
      return;
    }
    setState(() {
      _isSaving = true;
    });
    if (this.widget._bete != null)
      message = await this._bloc.savePesee(this.widget._bete!, poids, DateFormat.yMd().parse( _datePeseeCtl.text) );
    if (this.widget._lamb != null)
      message = await this._bloc.savePeseeLamb(this.widget._lamb!, poids, DateFormat.yMd().parse( _datePeseeCtl.text ) );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }
*/
  void showSaving () {
    setState(() {
      _isSaving = true;
    });

  }

  void showErrorWeighing () {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key("SnackBar"),
        content: Text(S.of(context).weighing_error)));
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

  LambModel ? get lamb => this.widget._lamb;

  Bete ? get bete => this.widget._bete;

}
