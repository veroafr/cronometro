import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/lap.dart';
import '../services/notification_service.dart';

class StopwatchViewModel extends ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  final NotificationService _notifications = NotificationService();

  Timer? _ticker;
  Timer? _resumeSuggestionTimer;

  Duration _lastLapMark = Duration.zero;
  List<Lap> _laps = [];

  // controla atualização da notificação persistente (1x por segundo)
  int _lastOngoingSecond = -1;

  Duration get elapsed => _stopwatch.elapsed;
  List<Lap> get laps => List.unmodifiable(_laps);
  bool get isRunning => _stopwatch.isRunning;

  String format(Duration d) {
    final ms = (d.inMilliseconds % 1000) ~/ 10; // centésimos
    final s = d.inSeconds % 60;
    final m = d.inMinutes % 60;
    final h = d.inHours;
    final hh = h > 0 ? '${h.toString().padLeft(2, '0')}:' : '';
    return '$hh${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')},${ms.toString().padLeft(2, '0')}';
  }

  Future<void> init() async {
    await _notifications.init();
  }

  void _startTicker() {
    _ticker?.cancel();
    // 200ms dá fluidez na UI e permite detectar virada de segundo
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      notifyListeners();

      if (_stopwatch.isRunning) {
        final sec = _stopwatch.elapsed.inSeconds;
        if (sec != _lastOngoingSecond) {
          _lastOngoingSecond = sec;
          _notifications.updateOngoing(
            title: 'Cronômetro em execução',
            body: 'Tempo: ${format(_stopwatch.elapsed)}',
          );
        }
      }
    });
  }

  Future<void> start() async {
    if (_stopwatch.isRunning) return;
    _stopwatch.start();
    _resumeSuggestionTimer?.cancel();
    _lastOngoingSecond = -1; // reinicia contador de segundo
    _startTicker();
    await _notifications.showOngoing(
      title: 'Cronômetro em execução',
      body: 'Tempo: ${format(elapsed)}',
    );
    notifyListeners();
  }

  Future<void> pause() async {
    if (!_stopwatch.isRunning) return;
    _stopwatch.stop();
    _ticker?.cancel();
    await _notifications.clearOngoing();

    // após 10s pausado, sugere retomar
    _resumeSuggestionTimer?.cancel();
    _resumeSuggestionTimer = Timer(const Duration(seconds: 10), () {
      _notifications.suggestResume();
    });
    notifyListeners();
  }

  Future<void> reset() async {
    _stopwatch.reset();
    _lastLapMark = Duration.zero;
    _laps = [];
    _ticker?.cancel();
    _resumeSuggestionTimer?.cancel();
    _lastOngoingSecond = -1;
    await _notifications.clearOngoing();
    notifyListeners();
  }

  Future<void> addLap() async {
    final total = elapsed;
    final lapTime = total - _lastLapMark;
    _lastLapMark = total;

    final lap = Lap(lapTime: lapTime, totalTime: total);
    _laps = [lap, ..._laps]; // mais recente no topo
    notifyListeners();

    await _notifications.showLap(
      title: 'Volta registrada',
      body: 'Volta: ${format(lapTime)} — Total: ${format(total)}',
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _resumeSuggestionTimer?.cancel();
    super.dispose();
  }
}
