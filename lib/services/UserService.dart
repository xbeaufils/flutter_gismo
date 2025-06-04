import 'dart:developer' as debug;

import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';

class UserService extends WebRepository{
  UserService(super.token);

  Future<User> auth(User user) async {
    try {
      //final response = await _dio.post( Environnement.getUrlTarget() + '/user/auth', data: user.toMap());
      final response = await super.doPostResult( '/user/auth',  user.toMap());
      debug.log("Send authentication", name: "WebDataProvider::auth");
      user.setCheptel(response["cheptel"]);
    }  catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    debug.log("User is $user.cheptel", name: "WebDataProvider::auth");
    return user;
  }

}