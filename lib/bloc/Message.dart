class Message {
  late bool error;
  late String message;
  Map ? result;

  Message(Map map) {
    error = map['error'];
    message = map['message'];
    result = map['result'];
  }
}