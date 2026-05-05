import '../../../../../domain/services/payment_service.dart';

class NullPaymentService implements PaymentService {
  @override
  Future<void> startPayment() async {}
}
