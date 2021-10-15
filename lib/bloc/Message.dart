class Message {
  late bool error;
  late String message;
  late Map result;

  Message(Map map) {
    error = map['error'];
    message = (map['message'] != null) ? map['message']: "";
    result = (map['result'] != null) ? map['result']: Map();
  }
}