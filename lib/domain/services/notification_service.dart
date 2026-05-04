abstract class NotificationService {
  Future<void> requestNotificationPermission();
  Stream<void> get onPaymentFinished;
}
