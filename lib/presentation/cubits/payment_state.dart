part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentSecurityChecking extends PaymentState {}

class PaymentSecurityBlocked extends PaymentState {
  final String reason;
  PaymentSecurityBlocked(this.reason);
}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {}
