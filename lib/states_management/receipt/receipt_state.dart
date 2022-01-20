part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();
  factory ReceiptState.initial() => ReceiptInitial();
  factory ReceiptState.sent(Receipt receipt) => ReceiptSentSuccess(receipt);
  factory ReceiptState.received(Receipt receipt) =>
      ReceiptReceivedSuccess(receipt);
  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

// message sent state impl
class ReceiptSentSuccess extends ReceiptState {
  final Receipt receipt;
  const ReceiptSentSuccess(this.receipt);

  @override
  List<Object> get props => [receipt];
}

// message received state impl
class ReceiptReceivedSuccess extends ReceiptState {
  final Receipt receipt;
  const ReceiptReceivedSuccess(this.receipt);

  @override
  List<Object> get props => [receipt];
}
