import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  final Connection _connection;
  final Rethinkdb r;

  UserService(this._connection, this.r);

  @override
  Future<User> connect(User user) async {
    // implement connect
    var data = user.toJson();
    if (user.id != null) data['id'] = user.id;

    final result = await r.table('user').insert(data, {
      'conflict': 'update',
      'return_changes': true,
    }).run(_connection);
    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    // implement disconnect
    await r.table('users').update({
      'id': user.id,
      'active': false,
      'last_seen': DateTime.now()
    }).run(_connection);
    _connection.close();
  }

  @override
  Future<List<User>> online() async {
    // implement online
    Cursor users =
        await r.table('users').filter({'active': true}).run(_connection);
    final userList = await users.toList();
    return userList.map((item) => User.fromJson(item)).toList();
  }
}
