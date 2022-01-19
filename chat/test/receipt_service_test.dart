import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

void main() {
  Rethinkdb r = Rethinkdb();
  Connection? connection;
  ReceiptService? sut;

  setUp(() async {
    connection = await r.connect();
    await createDB(r, connection!);
    sut = ReceiptService(r, connection!);
  });

  tearDown(() async {
    sut?.dispose();
    await cleanDB(r, connection!);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastseen': DateTime.now(),
  });

  test('sent receipt successfully', () async {
    Receipt receipt = Receipt(
        recipient: '444',
        messageId: '1234',
        status: ReceiptService.deliverred,
        timestamp: DateTime.now());

    final res = await sut?.send(receipt);
    expect(res, true);
  });

  test('successfully subscribe and receive receipts', () async {
    sut?.receipts(user).listen(expectAsync1((receipt) {
          expect(receipt.recipient, user.id);
        }, count: 2));
    Receipt receipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptService.deliverred,
        timestamp: DateTime.now());

    Receipt anotherReceipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptService.read,
        timestamp: DateTime.now());

    await sut?.send(receipt);
    await sut?.send(anotherReceipt);
  });
}
