import 'package:flutter/material.dart';
import 'app.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); 
  runApp(const LapTimerApp());
}
