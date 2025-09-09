import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // Canal das notificações
  static const String _channelId   = 'lap_timer_channel_v2';
  static const String _channelName = 'Cronômetro';
  static const String _channelDesc = 'Notificações do cronômetro de voltas';

  Future<void> init() async {
    // Inicialização
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iOSInit);
    await _plugin.initialize(initSettings);

    // Cria canal (Android) e pede permissão em runtime (Android 13+)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      // defaultImportance para maior visibilidade (pode ser LOW se preferir discretas)
      importance: Importance.defaultImportance,
    ));

    await android?.requestNotificationsPermission();

    // iOS: garante as permissões
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Mostra a notificação persistente quando iniciar o cronômetro.
  Future<void> showOngoing({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        ongoing: true,
        onlyAlertOnce: true,
        showWhen: false,
        category: AndroidNotificationCategory.progress,
        visibility: NotificationVisibility.public,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _plugin.show(1, title, body, details); // ID fixo para conseguir atualizar/cancelar
  }

  /// Atualiza o conteúdo da notificação persistente (mesmo ID).
  Future<void> updateOngoing({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        ongoing: true,
        onlyAlertOnce: false,
        showWhen: false,
        category: AndroidNotificationCategory.progress,
        visibility: NotificationVisibility.public,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _plugin.show(1, title, body, details);
  }

  /// Notificação para cada volta registrada (ID único por timestamp).
  Future<void> showLap({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(id, title, body, details);
  }

  /// Lembrete quando ficar pausado por mais de 10s.
  Future<void> suggestResume() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _plugin.show(
      2,
      'Cronômetro pausado',
      'Toque para retomar a contagem.',
      details,
    );
  }

  /// Remove a notificação persistente.
  Future<void> clearOngoing() async {
    await _plugin.cancel(1);
  }
}
