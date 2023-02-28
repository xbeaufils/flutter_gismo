import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeseePage extends StatefulWidget {
  final GismoBloc _bloc;
  final Bete ? _bete;
  final LambModel ? _lamb;

  @override
  PeseePageState createState() => PeseePageState(this._bloc);

  PeseePage(this._bloc,this._bete, this._lamb);
}

class PeseePageState extends State<PeseePage> {
  final GismoBloc _bloc;
  PeseePageState(this._bloc);
  //double _pesee = 0.0;
  TextEditingController _datePeseeCtl = TextEditingController();
  TextEditingController _poidsCtl = TextEditingController();
  final _df = new DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(t!.weighing),
        //leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _datePeseeCtl,
                decoration: InputDecoration(
                    labelText: t!.weighing_date,
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return t!.no_weighing_date;
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
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _datePeseeCtl.text = _df.format(date!);
                    });
                  }
                }),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: _poidsCtl,
              decoration: InputDecoration(
                  labelText: t!.weight,
                  hintText: t.weighing_hint),
                validator: (value) {
                  if (value!.isEmpty) {
                    return t.no_weight_entered;
                  }},
                onSaved: (value) {
                  setState(() {
                    _poidsCtl.text = value!;
                  });
                }
            ),
            (_isSaving) ? CircularProgressIndicator():
              ElevatedButton(
                child: Text(t!.bt_save,
                  style: new TextStyle(color: Colors.white, ),),
                //color: Colors.lightGreen[700],
                onPressed: _savePesee)
          ]),

    );
  }

  @override
  void initState() {
    super.initState();
    _datePeseeCtl.text = _df.format(DateTime.now());
  }

  void _savePesee() async {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    double? poids = double.tryParse(_poidsCtl.text);
    String message="";
    if (poids == null) {
      message = "";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLocalizations!.weighing_error)));
      return;
    }
    setState(() {
      _isSaving = true;
    });
    if (this.widget._bete != null)
      message = await this._bloc.savePesee(this.widget._bete!, poids, _datePeseeCtl.text);
    if (this.widget._lamb != null)
      message = await this._bloc.savePeseeLamb(this.widget._lamb!, poids, _datePeseeCtl.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }

}
