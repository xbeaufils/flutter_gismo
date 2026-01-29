import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/services/AuthService.dart';

class GismoDrawer extends StatelessWidget {
  GismoDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: Key("drawer"),
      child: ListView(
        children: [
          this._userstatus(context),
          Column(
            children: [
              ListTile(
                title: Text(S.of(context).welcome),
                leading: Icon(Icons.home),
                onTap:() { _homePressed(context);},
              ),
              _showConfig(context),
              _showBlueTooth(context),
          ]),
    ]));
  }

  Widget _showConfig(BuildContext context) {
    if (kIsWeb)
      return Container();
    return ListTile(
      title: Text(S.of(context).configuration),
      leading: Icon(Icons.settings),
      onTap:  () { _settingPressed(context);},
    );

  }

  Widget _showBlueTooth(BuildContext context) {
    if (kIsWeb)
      return Container();
    if (AuthService().subscribe)
      return  ListTile(
        title: Text("Bluetooth"),
        leading: Icon(Icons.edit),
        onTap: () { _choixBt(context);},
      );
    return Container();
  }

  void _choixBt(BuildContext context) {
    Navigator.pushNamed(context, '/bluetooth');
  }

  void _settingPressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/config') ;
  }

  void _homePressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/welcome') ;
  }

  void _notePressed( BuildContext context) {
    Navigator.pushReplacementNamed(context, '/note') ;
  }

  Widget _userstatus(BuildContext context) {
    Icon iconConnexion = Icon(Icons.person);
    Text userName = new Text(S.of(context).localuser);
    Text cheptel = new Text("000000");
    if (AuthService().subscribe) {
      iconConnexion = Icon(Icons.verified_user);
      userName = new Text(AuthService().email!);
      cheptel = new Text(AuthService().cheptel!);
    }
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.lightGreen,
      ),
      child: ListTile(
        title: userName,
        subtitle: cheptel,
        leading: CircleAvatar(
          child: iconConnexion,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
