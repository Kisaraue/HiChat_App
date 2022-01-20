import 'package:flutter/foundation.dart';
import 'package:hichat/data/datasource/datasource_contract.dart';
import 'package:hichat/models/chat.dart';
import 'package:hichat/models/local_message.dart';

abstract class BaseViewModel {
  IDatasource _datasource;

  BaseViewModel(this._datasource);
  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId))
      await _createNewChat(message.chatId);
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId, mostRecent: null);
    await _datasource.addChat(chat);
  }
}
