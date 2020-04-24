import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/User.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/welcome.dart';

enum TestConfig{NOT, WRONG, RIGHT}

class ConfigPage extends StatefulWidget {
  GismoBloc _bloc;
  ConfigPage(this._bloc, {Key key}) : super(key: key);
  @override
  _ConfigPageState createState() => new _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentStep = 0;
  bool _isSubscribed = false;
  TestConfig _isTested = TestConfig.NOT;
  final _cheptelCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();

  List<Step> _steps;
 // List<Step> get steps => _steps;

  List<Step> _buildSteps() {
    debug.log("curentStep = " + _currentStep.toString());
    _steps = [
      _getCheptel(),
      _getAbonnementStep(),
      _getConfirm()
    ];
    return _steps;
  }

   void switched(value) {
    this.setState(() {
      this._isSubscribed = value;
      if (this._isSubscribed)
        _isTested = TestConfig.NOT;
    });
  }

  Step _getAbonnementStep() {
    return Step(
      title: const Text('Abonnement'),
      isActive: true,
      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
      content:  Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: Text("Avec abonnement")
          ),
          Switch(
            value: _isSubscribed,
            onChanged: (value) {switched(value);},
          ),
          ]),
        TextFormField(
          controller: _emailCtrl,
          enabled: _isSubscribed ,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          controller: _tokenCtrl,
          enabled: _isSubscribed,
          decoration: InputDecoration(labelText: 'Token'),
        ),
      ],
    ));
  }

  Step _getCheptel() {
    return Step(
      isActive: true,
      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
      title: const Text('Cheptel'),
      content: Column(
        children: <Widget>[
          TextFormField(
            controller: _cheptelCtrl,
            decoration: InputDecoration(labelText: 'Numero Cheptel'),
          ),
        ],
      ),
    );
  }

  Step _getConfirm() {
    return Step(
      isActive: true,
      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
      title: const Text('Confirmation'),
      content: Column(
        children: <Widget>[
         _messageConfig(),

        ],
      ),
    );

  }

  Widget _messageConfig() {
    if ( ! _isSubscribed)
      return  Text("Enregistrer la configuration");
    else if (_isTested == TestConfig.NOT)
      return  Text("Tester la configuration");
    else if (_isTested == TestConfig.WRONG)
      return Text("La configuration (cheptel, email, token) n'est pas bonne");
    else return Text("La configuration est correcte");
  }

  _saveConfig() {
    //AuthService service = new AuthService();
    if (this._isSubscribed) {
      gismoBloc.saveWebConfig(_cheptelCtrl.text, _emailCtrl.text, _tokenCtrl.text)
          .then((message) {_confirmSave();})
          .catchError((e) {_onError(e);});
    }
    else
      gismoBloc.saveLocalConfig(_cheptelCtrl.text)
          .then( (message) {_confirmSave();})
          .catchError((e)  {_onError(e);});
  }

  void _confirmSave() {
    debug.log("Cheptel is " , name: "_ConfigPageState::_confirmSave");
    String message = "Parametres sauvegardés";
    if (Navigator.canPop(context))
      Navigator.pop(context, message);
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage(null)));
  }

  void _onError(e) {
    final snackBar = SnackBar(content: Text(e),);
    debug.log("Cheptel is " , name: "_ConfigPageState::_onError");
    FocusScope.of(context).unfocus();
    _scaffoldKey.currentState.showSnackBar(snackBar);
   }

  @override
  Widget build(BuildContext context) {
    debug.log("Build" , name: "_ConfigPageState:Build");
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Configuration'),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: new Stepper(
              currentStep: _currentStep,
              steps: _buildSteps(),
              type: StepperType.vertical,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel ,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) { return _controleBuilder();},

            ),
          ),
          Container(),
        ]));
  }

  Widget _controleBuilder() {
    if (_currentStep == 2) {
      // Dernier step
      if (!_isSubscribed)
        // Si pas de souscription, pas de test
        return _buttonBardEndTested();
      else {
        if (_isTested == TestConfig.RIGHT)
          // Souscription et test OK
          return _buttonBardEndTested();
        else
          return _buttonBarEndNotTested();
      }
     }
    return _buttonBarClassic();
  }

  Widget _buttonBarEndNotTested() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child:
      new RaisedButton(
        child: new Text('Tester config',style: new TextStyle(color: Colors.white),),
        onPressed: _testConfigPressed, color: Colors.lightGreen[700],)
    );
  }

  Widget _buttonBardEndTested() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child:
      new RaisedButton(
        child: new Text('Enregistrer',style: new TextStyle(color: Colors.white),),
        onPressed: _saveConfig, color: Colors.lightGreen[700],)
    );
  }

  Widget _buttonBarClassic() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                onPressed: _onStepCancel,
                child: Row( children: <Widget>[
                  Icon(Icons.navigate_before),
                  const Text('Précédent')
                ],)
            ),
            FlatButton(
                onPressed: _onStepContinue,
                child: Row( children: <Widget>[
                  const Text('Suivant'),
                  Icon(Icons.navigate_next),
                ],)
            ),
          ],
        ),
    );
  }

  void _testConfigPressed() {
    /*
    User user = User(_cheptelCtrl.text);
    user.setEmail(_emailCtrl.text);
    user.setToken(_tokenCtrl.text);
    gismoBloc.auth(user)
        .then( (user) => {_testConfigOk(user)})
        .catchError((e) => {_testConfigBad()});
     */
  }

  void _testConfigOk(User user) {
    setState(() {
      _isTested = TestConfig.RIGHT;
    });
  }

  void _testConfigBad() {
    setState(() {
      _isTested = TestConfig.WRONG;
    });
  }
  _onStepContinue () {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep ++;
      } else {
        this._currentStep = 0;
      }
    });
  }
  _onStepCancel () {
    setState(() {
      if (_currentStep > 0) {
        _currentStep --;
      } else {
        _currentStep = 0;
      }
    });
  }

  @override
  void initState() {
    debug.log("initState", name: "_ConfigPageState:initState");
    super.initState();
    if (this.widget._bloc.user != null) {
      _cheptelCtrl.text = this.widget._bloc.user.cheptel;
      _emailCtrl.text = this.widget._bloc.user.email;
      _tokenCtrl.text = this.widget._bloc.user.token;
      if (this.widget._bloc.user.subscribe != null)
        _isSubscribed = this.widget._bloc.user.subscribe;

    }
  }

  @override
  void dispose() {
    super.dispose();
    _cheptelCtrl.dispose();
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
  }
}

