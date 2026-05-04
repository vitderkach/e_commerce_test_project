import '../../../../domain/services/notification_service.dart';

class NullNotificationService implements NotificationService {
  @override
  Future<void> requestNotificationPermission() async {}
}
