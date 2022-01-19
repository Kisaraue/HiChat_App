import 'package:hichat/models/local_message.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage>? messages = [];
  LocalMessage? mostRecent;

  Chat(this.id, {this.messages, required this.mostRecent});

  toMap() => {'id': id};
  factory Chat.fromMap(Map<String, dynamic> json) =>
      Chat(json['id'], mostRecent: null);
}
