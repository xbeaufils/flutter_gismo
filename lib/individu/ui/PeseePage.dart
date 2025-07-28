import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/individu/presenter/PeseePresenter.dart';
import 'package:intl/intl.dart';

class PeseePage extends StatefulWidget {
  final Bete ? _bete;

  final LambModel ? _lamb;

  @override
  PeseePageState createState() => PeseePageState();

  PeseePage(this._bete, this._lamb);

}

abstract class PeseeContract extends GismoContract{
  Bete ? get bete;
  LambModel ? get lamb;
  void showSaving ();
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
              FilledButton(
                child: Text(S.of(context).bt_save),
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
  void showSaving () {
    setState(() {
      _isSaving = true;
    });

  }

  LambModel ? get lamb => this.widget._lamb;

  Bete ? get bete => this.widget._bete;

}
