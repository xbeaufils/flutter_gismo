import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class PeseePage extends StatefulWidget {
  final GismoBloc _bloc;
  final Bete _bete;

  @override
  PeseePageState createState() => PeseePageState(this._bloc);

  PeseePage(this._bloc,this._bete);
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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("Pesée"),
        leading: Text(this.widget._bete.numBoucle),
      ),
      body:
      new Column(
          children: <Widget> [
            new TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _datePeseeCtl,
                decoration: InputDecoration(
                    labelText: "Date de pesée",
                    hintText: 'jj/mm/aaaa'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Pas de date de pesée";
                  }},
                onSaved: (value) {
                  setState(() {
                    _datePeseeCtl.text = value;
                  });
                },
                onTap: () async{
                  DateTime date = DateTime.now();
                  FocusScope.of(context).requestFocus(new FocusNode());
                  date = await showDatePicker(
                      locale: const Locale("fr","FR"),
                      context: context,
                      initialDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    setState(() {
                      _datePeseeCtl.text = _df.format(date);
                    });
                  }
                }),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: _poidsCtl,
              decoration: InputDecoration(
                  labelText: "Poids",
                  hintText: 'Poids en kg'),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Pas de poids saisi";
                  }},
                onSaved: (value) {
                  setState(() {
                    _poidsCtl.text = value;
                  });
                }
            ),
            (_isSaving) ? CircularProgressIndicator():
              RaisedButton(
                child: Text('Enregistrer',
                  style: new TextStyle(color: Colors.white, ),),
                color: Colors.lightGreen[700],
                onPressed: _savePesee)
          ]),

    );
  }

  @override
  void initState() {
    super.initState();
    _datePeseeCtl.text = _df.format(DateTime.now());
   // _nec = this.widget._currentLevel;
  }

  void _savePesee() async {
    double poids = double.tryParse(_poidsCtl.text);
    //double.tryParse(_poidsCtl.text, NumberStyles.Any, CultureInfo.CurrentCulture, out localCultreResult);
    String message;
    if (poids == null) {
      message = "Le poids n'est pas au format numérique";
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    setState(() {
      _isSaving = true;
    });
      message =
      await this._bloc.savePesee(this.widget._bete, poids, _datePeseeCtl.text);
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((e) => {Navigator.of(context).pop()});
  }

}
