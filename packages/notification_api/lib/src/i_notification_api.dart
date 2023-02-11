import 'models/active_notification.dart';

abstract class INotificationsApi {
  const INotificationsApi();

  /// Returns the active notifications
  Future<List<ActiveNotification?>> getActiveNotifications();

  /// Set a new notification
  Future<void> setNotification();
}
