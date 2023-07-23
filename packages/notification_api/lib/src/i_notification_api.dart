abstract class INotificationsApi {
  const INotificationsApi();

  // Returns if a Notification of the API is pending
  Future<bool> get isNotificationPending;

  /// Set a new notification
  Future<void> setNotification(
    String message,
    DateTime notificationDate,
  );
}
