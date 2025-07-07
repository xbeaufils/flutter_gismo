import 'package:flutter/material.dart';
import 'package:flutter_gismo/Lot/presenter/AffectationPresenter.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:intl/intl.dart';

class AffectationPage  extends StatefulWidget {

  Affectation _affectation;
  AffectationPageState createState() => new AffectationPageState();

  AffectationPage(this._affectation);
}

class AffectationPageState extends GismoStatePage<AffectationPage> {
  TextEditingController _dateEntreeCtl = TextEditingController();
  TextEditingController _dateSortieCtl = TextEditingController();
  bool _isSaving = false;
  late AffectationPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: Text(S.of(context).batch_date),

    ),
    body:
        Column( children: [
          TextFormField(
            keyboardType: TextInputType.datetime,
            controller: _dateEntreeCtl,
            decoration: InputDecoration(
                labelText: S.current.dateEntry),
            validator: (value) {
              if (value!.isEmpty) {
                return S.of(context).enter_lambing_date;
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _dateEntreeCtl.text = value!;
              });
            },
            onTap: () async{
              DateTime ? date = DateTime.now();
              FocusScope.of(context).requestFocus(new FocusNode());
              date = await showDatePicker(
                  context: context,
                  initialDate:DateTime.now(),
                  firstDate:DateTime(1900),
                  lastDate: DateTime(2100)) ;
              if (date != null) {
                setState(() {
                  _dateEntreeCtl.text = DateFormat.yMd().format(date!);
                });
              }
            }),
          TextFormField(
              keyboardType: TextInputType.datetime,
              controller: _dateSortieCtl,
              decoration: InputDecoration(
                  labelText: S.current.dateDeparture,),
              validator: (value) {
                if (value!.isEmpty) {
                  return S.of(context).enter_lambing_date;
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _dateSortieCtl.text = value!;
                });
              },
              onTap: () async{
                DateTime ? date = DateTime.now();
                FocusScope.of(context).requestFocus(new FocusNode());
                date = await showDatePicker(
                    context: context,
                    initialDate:DateTime.now(),
                    firstDate:DateTime(1900),
                    lastDate: DateTime(2100)) ;
                if (date != null) {
                  setState(() {
                    _dateSortieCtl.text = DateFormat.yMd().format(date!);
                  });
                }
              }),
          (_isSaving) ? CircularProgressIndicator():
          ElevatedButton(
              child: Text(S.of(context).bt_save,
                style: new TextStyle(color: Colors.white, ),),
              //color: Colors.lightGreen[700],
              onPressed: () => this._presenter.save(_dateEntreeCtl.text, _dateSortieCtl.text) )

        ],)
    );

  }
}