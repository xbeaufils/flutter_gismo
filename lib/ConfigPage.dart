import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/menu/MenuPage.dart';
import 'package:flutter_gismo/model/User.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/welcome.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

enum TestConfig{NOT, DONE}
enum ConfirmAction { CANCEL, ACCEPT }

class ConfigPage extends StatefulWidget {
  final GismoBloc _bloc;
  ConfigPage(this._bloc, {Key ? key}) : super(key: key);
  @override
  _ConfigPageState createState() => new _ConfigPageState(_bloc);
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  int _compositionCheptel = 1;

  _ConfigPageState(this._bloc);

  bool _isSubscribed = false;
  TestConfig configTeste = TestConfig.NOT;
  final _cheptelCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void switched(value) {
    this.setState(() {
      this._isSubscribed = value;
      if (this._isSubscribed)
        configTeste = TestConfig.NOT;
     });
  }

  Widget _loginPage() {
    return  new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(S.of(context).connected_mode),
              subtitle: Text(S.of(context).connected_mode_text),
            isThreeLine: true,),
            new Card(key: null,
              child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(S.of(context).email,
                    ),
                    new TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: S.of(context).email,
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                    new Text(S.of(context).password),
                    new TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: S.of(context).password,
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                    new ElevatedButton(key:null, onPressed:_login,
                        //color: const Color(0xFFe0e0e0),
                        child:
                        new Text(S.of(context).connection,
                          style: new TextStyle(
                            color: const Color(0xFF000000),),
                        )
                    )
                  ]
              ),
            ),

          ]
      );

  }

  Widget _autonomePage() {
    return new Column(children: <Widget>[
      ListTile(
        title: Text(S.of(context).alone_mode),
        subtitle: Text(S.of(context).alone_mode_text),
        isThreeLine: true,
      ),
        FutureBuilder(
            builder: (context,AsyncSnapshot projectSnap) {
              switch (projectSnap.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container();
                default:
                  if (projectSnap.data == null)
                    return Container(child: Text(S.of(context).data_null),);
                  if (projectSnap.data.length == 0 ) {
                    return Container(child: Text(S.of(context).empty_folder),);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: projectSnap.data.length,
                    itemBuilder: (context, index) {
                      FileSystemEntity file = projectSnap.data[index];
                      String filename = path.basename( file.path);
                      return new Column(
                          children: <Widget>[
                            new ListTile(
                              title: Text(filename), 
                              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => this._deleteBackup(filename) ,), 
                              leading: IconButton(icon: Icon(Icons.restore), onPressed: () => this._restoreBackup(filename)) ,)
                          ]);
                    },
                  );
              }
            },
            future: _getFiles(),
        ),
      new ElevatedButton(key:null, onPressed:_copyBD,
          //color: const Color(0xFFe0e0e0),
          child:
          new Text(S.of(context).copy_base,
            style: new TextStyle(
              color: const Color(0xFF000000),),
          )
      )

    ],
    );
  }
  
  Future<List<FileSystemEntity>?>  _getFiles() async {
    /*
    var permission = Permission.storage;
    final PermissionStatus status = await permission.request();
     */
    final Directory ? extDir = await getExternalStorageDirectory();
    if (extDir == null)
      return null;
    final Directory backupDir = Directory(extDir.path + '/backup');
    if (! backupDir.existsSync())
      return [];
    //final isPermissionStatusGranted = await _requestPermissions();
    List<FileSystemEntity> files = backupDir.listSync();
    return files;
  }

  void _deleteBackup(String nameFile) {
      this._bloc.deleleteBackup(nameFile);
      setState(() {

      });
  }

  void _copyBD() {
    this._bloc.copyBD();
  }

  void _restoreBackup(String filename) {
      this._asyncConfirmDialog(context).then((value) => {
        if (value == ConfirmAction.ACCEPT)
          this._bloc.restoreBackup(filename)
      }
      );
  }

  void _login() async {
      User testUser  = User(_emailCtrl.text, _passwordCtrl.text);
      try {
        User testedUser = await this._bloc.login(testUser);
        setState(() {
          configTeste = TestConfig.DONE;
        });
      } catch(e) {
        _onError(e);
      }

  }

  Future _asyncConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).restore_bd),
          content: Text(S.of(context).restore_bd_text),
          actions: [
            TextButton(
              child: Text(S.of(context).bt_cancel),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            TextButton(
              child: Text(S.of(context).bt_continue),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  void _saveConfig() {
    this._bloc.saveConfig(this._isSubscribed, _emailCtrl.text, _passwordCtrl.text, _compositionCheptel)
        .then((message) {_confirmSave();})
        .catchError((e) {_onError(e);});
   }

  void _confirmSave() {
    debug.log("Cheptel is " , name: "_ConfigPageState::_confirmSave");
    String message = "Parametres sauvegardés";
    if (Navigator.canPop(context))
      Navigator.pop(context, message);
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => WelcomeMainPage(this._bloc, null)));
  }

  void _onError(e) {
    final snackBar = SnackBar(content: Text(e),);
    debug.log("Cheptel is " , name: "_ConfigPageState::_onError");
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
   }

  @override
  Widget build(BuildContext context) {
    debug.log("Build" , name: "_ConfigPageState:Build");
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (! _isSubscribed || configTeste == TestConfig.DONE)?
        FloatingActionButton.extended(
            onPressed: _saveConfig,
            label: Text(S.of(context).save_config),
            icon: Icon(Icons.save),
        ): null ,
        appBar: AppBar(
          title: Text(S.of(context).configuration),
        ),
        body:
          SingleChildScrollView(
            child:
              Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(child:
                    Text(S.of(context).cheptel_type)),]),
                Row(children: [
                  Expanded(child:
                    Column(children: [
                      ListTile(
                        title: Text(S.of(context).only_ovins),
                        leading: Radio(
                          value: 1,
                          groupValue: _compositionCheptel,
                          onChanged: ( value) {
                            setState(() {
                              _compositionCheptel = value!;
                            });
                          },
                        ),),
                      ListTile(
                          title: Text(S.of(context).only_caprins),
                          leading: Radio(
                            value: 2,
                            groupValue: _compositionCheptel,
                            onChanged: ( value) {
                              setState(() {
                                _compositionCheptel = value!;
                              });
                            },
                          )),
                      ListTile(
                          title: Text(S.of(context).ovins_caprins),
                          leading: Radio(
                            value: 3,
                            groupValue: _compositionCheptel,
                            onChanged: ( value) {
                              setState(() {
                                _compositionCheptel = value!;
                              });
                            },
                          ))
                    ],)
                  ,)
                ],),
                Row(children: <Widget>[
                      Expanded(
                          child: Text(S.of(context).with_subscription)
                      ),
                      Switch(
                        value: _isSubscribed,
                        onChanged: (value) {switched(value);},
                      ),
                    ]),
                AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: _isSubscribed ? _loginPage(): _autonomePage(),
                  ),
               ])
          ),
        drawer: GismoDrawer(_bloc),);
  }

  @override
  void initState() {
    debug.log("initState", name: "_ConfigPageState:initState");
    super.initState();
    if (_bloc.user != null) {
      if (_bloc.user!.email != null)
        _emailCtrl.text = _bloc.user!.email!;
      if (_bloc.user!.subscribe != null)
        _isSubscribed = _bloc.user!.subscribe!;
    }
    if (_isSubscribed) {
      configTeste = TestConfig.DONE;
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

