import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/security_service.dart';
import '../../domain/services/payment_service.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final SecurityService _securityService;
  final PaymentService _paymentService;

  PaymentCubit({
    required SecurityService securityService,
    required PaymentService paymentService,
  })  : _securityService = securityService,
        _paymentService = paymentService,
        super(PaymentInitial());

  Future<void> checkSecurityAndPay() async {
    emit(PaymentSecurityChecking());
    
    final isRooted = await _securityService.isRooted();
    final isRecording = await _securityService.isScreenRecording();

    if (isRooted || isRecording) {
      String reason = isRooted ? "Device is rooted" : "Screen recording detected";
      emit(PaymentSecurityBlocked(reason));
      return;
    }

    emit(PaymentProcessing());
    await _paymentService.startPayment();
    emit(PaymentSuccess());
  }

  void reset() {
    emit(PaymentInitial());
  }
}
