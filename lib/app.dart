import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/stopwatch_viewmodel.dart';
import 'views/stopwatch_page.dart';

class LapTimerApp extends StatelessWidget {
  const LapTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StopwatchViewModel()..init(),
      child: MaterialApp(
            debugShowCheckedModeBanner: false,

        title: 'Cronômetro',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xFF2BA6FF),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 84, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(fontSize: 16, fontFeatures: [FontFeature.tabularFigures()]),
            bodyMedium:  TextStyle(fontSize: 16, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ),
        home: const StopwatchPage(),
      ),
    );
  }
}
