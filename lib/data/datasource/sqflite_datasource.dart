import 'package:hichat/data/datasource/datasource_contract.dart';
import 'package:hichat/models/local_message.dart';
import 'package:hichat/models/chat.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;

  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    // implement addChat
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    // implement addMessage
    await _db.insert('messages', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    // implement deleteChat
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    // implement findAllChats
    return _db.transaction((txn) async {
      final chatsWithLatestMessage =
          await txn.rawQuery(''' SELECT messages.* FROM
      (SELECT
        chat_id, MAX(created_at) AS created_at
        FROM messages
        GROUP BY chat_id
      ) AS lastest_messages
      INNER JOIN messages
      ON messages.chat_id = lastest_messages.chat_id
      AND messages.created_at = latest_messages.created_at
      ''');

      if (chatsWithLatestMessage.isEmpty) return [];

      final chatsWithUnreadMessages =
          await txn.rawQuery('''SELECT chat_id, count(*) as unread
      FROM messages
      WHERE receipt = ?
      GROUP BY chat_id
      ''', ['deliverred']);

      return chatsWithLatestMessage.map<Chat>((row) {
        final int unread = int.tryParse(chatsWithUnreadMessages.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread']);

        final chat = Chat.fromMap(row);
        chat.unread = unread;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    // implement findChat
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread!;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatID) async {
    // implement findMessages
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatID],
    );

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    // implement updateMessage
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
