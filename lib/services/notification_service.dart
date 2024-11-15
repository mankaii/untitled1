import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _scheduleDailyNotification(
      int hour,
      int minutes,
      int id,
      String title,
      String body,
      ) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'daily_notification',
          '금연 알림',
          channelDescription: '일일 금연 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleDailyNotifications() async {
    // 아침 9시 알림
    await _scheduleDailyNotification(
      9,
      0,
      1,
      '금연 체크',
      '오늘도 금연 실천하는 멋진 하루 되세요! 💪',
    );

    // 점심 1시 알림
    await _scheduleDailyNotification(
      13,
      0,
      2,
      '금연 체크',
      '점심시간입니다. 건강한 하루 보내세요! 🌱',
    );

    // 저녁 7시 알림
    await _scheduleDailyNotification(
      19,
      0,
      3,
      '금연 체크',
      '오늘 하루도 수고하셨습니다. 금연을 위한 당신의 노력을 응원합니다! ⭐',
    );
  }

  Future<void> showTestNotification() async {
    await _notificationsPlugin.show(
      0,
      '테스트 알림',
      '알림 기능이 정상적으로 작동합니다! 👍',
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'test_notification',
          '테스트 알림',
          channelDescription: '알림 기능 테스트용',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}