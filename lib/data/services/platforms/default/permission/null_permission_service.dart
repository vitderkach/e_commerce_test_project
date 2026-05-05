import '../../../../../domain/services/permission_service.dart';

class NullPermissionService implements PermissionService {
  @override
  Future<void> requestNotificationPermission() async {}
}
