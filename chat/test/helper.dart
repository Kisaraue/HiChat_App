import 'package:rethinkdb_dart/rethinkdb_dart.dart';

//create database
Future<void> createDB(Rethinkdb r, Connection connection) async {
  await r.dbCreate('test').run(connection).catchError((err) => {});
  await r
      .tableCreate('users')
      .run(connection)
      .catchError((err) => {}); //create table users
  await r
      .tableCreate('messages')
      .run(connection)
      .catchError((err) => {}); //create table messages

  await r
      .tableCreate('receipts') //create table receipts
      .run(connection)
      .catchError((err) => {});
}

//delete table
Future<void> cleanDB(Rethinkdb r, Connection connection) async {
  await r.table('users').delete().run(connection); // delete table users
  await r.table('messages').delete().run(connection); //delete table messages
  await r.table('receipts').delete().run(connection); //delete table receipts
}
