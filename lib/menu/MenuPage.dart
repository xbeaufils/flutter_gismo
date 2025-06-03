import 'package:flutter/material.dart';
import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:provider/provider.dart';

class GismoDrawer extends StatelessWidget {
  GismoDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              ListTile(
                title: Text(S.of(context).memo),
                leading: Icon(Icons.note),
                onTap: () { _notePressed(context);},
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              ListTile(
                title: Text(S.of(context).configuration),
                leading: Icon(Icons.settings),
                onTap:  () { _settingPressed(context);},
              ),
              _showBlueTooth(context),
          ]),
    ]));
  }

  Widget _showBlueTooth(BuildContext context) {
    ConfigProvider provider = Provider.of<ConfigProvider>(context);
    if (provider.currentUser == null)
      return Container();
    if (provider.isSubscribing())
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
    ConfigProvider provider = Provider.of<ConfigProvider>(context);
    Icon iconConnexion = Icon(Icons.person);
    Text userName = new Text(S.of(context).localuser);
    Text cheptel = new Text("000000");
    if (provider.currentUser == null) {
      iconConnexion = Icon(Icons.error_outline);
      userName = new Text(S.of(context).user_error);
    } else
      if (! provider.isSubscribing()) {
        iconConnexion = Icon(Icons.error_outline);
        userName = new Text(S.of(context).user_error);
      } else {

        if (provider.isSubscribing()) {
          iconConnexion = Icon(Icons.verified_user);
          userName = new Text(provider.currentUser!.email!);
          cheptel = new Text(provider.currentUser!.cheptel!);
        }
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
