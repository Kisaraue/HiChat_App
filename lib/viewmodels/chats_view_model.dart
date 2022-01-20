import 'package:chat/chat.dart';
import 'package:hichat/data/datasource/datasource_contract.dart';
import 'package:hichat/models/chat.dart';
import 'package:hichat/models/local_message.dart';
import 'package:hichat/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;

  ChatsViewModel(this._datasource) : super(_datasource);

  // get chats list in UI
  Future<List<Chat>> getChats() async => await _datasource.findAllChats();

  // show received messages in UI
  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
