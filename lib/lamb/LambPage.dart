import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/individu/PeseePage.dart';
import 'package:flutter_gismo/lamb/Bouclage.dart';
import 'package:flutter_gismo/lamb/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';

class LambPage extends StatefulWidget {
  final GismoBloc _bloc;
  LambModel _lamb;


  @override
  LambPageState createState() => LambPageState();

  LambPage.edit(this._bloc, this._lamb);
  LambPage(this._bloc);
}

class LambPageState extends State<LambPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _marquageCtrl = TextEditingController();
  Sex _sex = Sex.male;
  Sante _sante = Sante.VIVANT;
  List<DropdownMenuItem<MethodeAllaitement>> _dropDownMenuItems;
  MethodeAllaitement _currentAllaitement;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: _mainTitle(),
          actions: _getActionButton(),
        ),
        body:
            SingleChildScrollView (child:
          Column(
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(labelText: 'Marquage provisoire'),
                  controller: _marquageCtrl,
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Flexible (child:
                        RadioListTile<Sex>(
                          title: const Text('Male'),
                          value: Sex.male,
                          groupValue: _sex,
                          onChanged: (Sex value) { setState(() { _sex = value; }); },
                        ),
                      ),
                      new Flexible( child:
                        RadioListTile<Sex>(
                          title: const Text('Femelle'),
                          value: Sex.femelle,
                          groupValue: _sex,
                          onChanged: (Sex value) { setState(() { _sex = value; }); },
                        ),
                      ),]

                ),
                new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Etat de santé"),
                        RadioListTile<Sante>(
                          dense: true,
                          title: const Text('Vivant'),
                          value: Sante.VIVANT,
                          groupValue: _sante,
                          onChanged: (Sante value) { setState(() { _sante = value; }); },
                        ),
                        RadioListTile<Sante>(
                          dense: true,
                          title: const Text('Mort-né'),
                          value: Sante.MORT_NE,
                          groupValue: _sante,
                          onChanged: (Sante value) { setState(() { _sante = value; }); },
                        ),
                        RadioListTile<Sante>(
                          dense: true,
                          title: const Text('Avorté'),
                          value: Sante.AVORTE,
                          groupValue: _sante,
                          onChanged: (Sante value) { setState(() { _sante = value; }); },
                        ),
                    ]
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Mode d'allaitement: "),
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                    ),
                    new DropdownButton(
                      value: _currentAllaitement,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  ],
                ),
                //new Row(
                //    mainAxisAlignment: MainAxisAlignment.center,
                //    mainAxisSize: MainAxisSize.max,
                //    children: <Widget>[
                      this._mainButton(),
                //    ]
                //),
                SizedBox(
                    height: 200,
                    child : (this.widget._lamb == null) ? Container() : _buildEvents())
              ]
          ),
    ),);
  }

  void _addLamb() {
    Navigator
        .of(context)
        .pop(new LambModel(this._marquageCtrl.text, this._sex, this._currentAllaitement, this._sante));
  }

  void _saveLamb() {
    this.widget._lamb.marquageProvisoire = this._marquageCtrl.text;
    this.widget._lamb.sex = this._sex;
    this.widget._lamb.allaitement = this._currentAllaitement;
    this.widget._lamb.sante = this._sante;
    Navigator
        .of(context)
        .pop(this.widget._lamb);
  }

  void changedDropDownItem(MethodeAllaitement selectedAllaitement) {
    setState(() {
      _currentAllaitement = selectedAllaitement;
    });
  }

  @override
  void initState() {
    List<DropdownMenuItem<MethodeAllaitement>> items = new List();
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_MATERNEL, child: new Text(MethodeAllaitement.ALLAITEMENT_MATERNEL.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ALLAITEMENT_ARTIFICIEL, child: new Text(MethodeAllaitement.ALLAITEMENT_ARTIFICIEL.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.ADOPTE, child: new Text(MethodeAllaitement.ADOPTE.libelle)));
    items.add(new DropdownMenuItem( value: MethodeAllaitement.BIBERONNE, child: new Text(MethodeAllaitement.BIBERONNE.libelle)));
    _dropDownMenuItems = items;
    if (this.widget._lamb != null) {
      _currentAllaitement = this.widget._lamb.allaitement;
      this._marquageCtrl.text = this.widget._lamb.marquageProvisoire;
      this._sex = this.widget._lamb.sex;
      this._sante = this.widget._lamb.sante;
    }
    else {
      _currentAllaitement = _dropDownMenuItems[0].value;
    }
    super.initState();
  }

  Widget _mainTitle() {
    if (this.widget._lamb == null)
      return Text('Nouvel agneau');
    return Text("Modification");
  }

  Widget _mainButton() {
    if (this.widget._lamb == null)
      return new RaisedButton(
          onPressed:_addLamb,
          color: Colors.lightGreen[900],
          child:
          new Text(
            "Ajouter",
            style: new TextStyle(color: Colors.white),
          )
      );
    return
      new RaisedButton.icon(
        onPressed:_saveLamb,
      //color: Colors.lightGreen[900],
        icon: Icon(Icons.save),
        label: Text("Enregistrer"),
      ) ;
  }

  List<Widget> _getActionButton() {
    List <Widget> actionButtons = List<Widget>();
    if (this.widget._lamb == null)
      actionButtons.add(Container());
    else {
      if (_sante != Sante.VIVANT)
        return null;
      else {
        if (this.widget._lamb.dateDeces != null ||
            this.widget._lamb.numBoucle != null)
          actionButtons.add(Container());
        else {
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/peseur.png"),
              onPressed: () {
                _openPesee(this.widget._lamb);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/syringe.png"),
              onPressed: () {
                _openTraitement(this.widget._lamb);
              },),);
          actionButtons.add(
            IconButton(
              icon: Image.asset("assets/tomb.png"),
              onPressed: () {
                _openDeath(this.widget._lamb);
              },),);
          actionButtons.add(
              IconButton(
                icon: Image.asset("assets/bouclage.png"),
                onPressed: () {
                  _openBoucle(this.widget._lamb);
                },));
        }
      }
    }
    return actionButtons;
  }

  Widget _buildEvents() {
     return FutureBuilder(
      builder:(context, eventSnap) {
        if (eventSnap.connectionState == ConnectionState.none ||
            eventSnap.hasData == false) {
          return Container();
        }
        if (eventSnap.connectionState == ConnectionState.waiting)
          return Center(child:  CircularProgressIndicator(),);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: eventSnap.data.length,
          itemBuilder: (context, index) {
            Event event = eventSnap.data[index];
            return new ListTile(
                leading: _getImageType(event.type),
                title: Text(event.eventName),
                subtitle: Text(event.date),
                trailing: IconButton(icon: Icon(Icons.delete), onPressed: () =>  _showDialog(context, event), )
            );
          },
        );
      },
      future: this.widget._bloc.getEventsForLamb(this.widget._lamb),
    );
  }

  void _openBoucle(LambModel lamb) async {
    Bete bete = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BouclagePage(lamb, this.widget._bloc)),
    );
    this.widget._bloc.boucler(lamb,bete);
    lamb.idDevenir = bete.idBd;
    lamb.numBoucle = bete.numBoucle;
    lamb.numMarquage = bete.numMarquage;
    Navigator
        .of(context)
        .pop(lamb);
  }
  
  void _openDeath(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MortPage(lamb, this.widget._bloc)),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  void _openPesee(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PeseePage(this.widget._bloc, null, lamb )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  void _openTraitement(LambModel lamb) async {
    var navigationResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SanitairePage(this.widget._bloc, null, lamb )),
    );
    print (navigationResult);
    Navigator
        .of(context)
        .pop(navigationResult);
  }

  Widget _getImageType(EventType type) {
    switch (type) {
      case EventType.traitement :
        return new Image.asset("assets/syringe.png");
        break;
      case EventType.agnelage :
        return new Image.asset("assets/lamb.png");
        break;
      case EventType.NEC:
        return new Image.asset("assets/etat_corporel.png");
        break;
      case EventType.entreeLot:
        return new Image.asset("assets/Lot_entree.png");
        break;
      case EventType.sortieLot:
        return new Image.asset("assets/Lot_sortie.png");
        break;
      case EventType.pesee:
        return new Image.asset("assets/peseur.png");
        break;
      case EventType.echo:
        return new Image.asset("assets/ultrasound.png");
      case EventType.entree:
      case EventType.sortie:
    }
    return null;
  }

  // set up the buttons
  Widget _cancelButton() {
    return FlatButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(Event event) {
    return FlatButton(
      child: Text("Continuer"),
      onPressed: () {
        if (event.type == EventType.pesee || event.type == EventType.traitement)
          _deleteEvent(event);
        Navigator.of(context).pop();
      },
    );
  }

  Future _showDialog(BuildContext context, Event event) {
    String message ="Voulez vous supprimer ";
    if (event.type == EventType.traitement)
      message += "ce traitement ?";
    if (event.type == EventType.pesee)
      message += "cette pesée ?";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Suppression"),
          content: Text(
              message),
          actions: [
            _cancelButton(),
            _continueButton(event),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) async {
    String message = await this.widget._bloc.deleteEvent(event);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {

    });
  }
}

