import 'dart:ui' show FontFeature; // <- necesario para FontFeature
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stopwatch_viewmodel.dart';
import 'widgets/circular_timer.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopwatchViewModel>();
    final elapsed = vm.elapsed;

    final cent = (elapsed.inMilliseconds % 1000) ~/ 10;
    final secs = elapsed.inSeconds % 60;
    final mins = elapsed.inMinutes % 60;
    final hours = elapsed.inHours;

    final mainText = (hours > 0)
        ? '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}'
        : secs.toString().padLeft(2, '0');
    final subText = cent.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Cronômetro')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Semantics(
              label: 'Tempo decorrido',
              value: vm.format(elapsed),
              liveRegion: true,
              child: CircularTimer(
                elapsed: elapsed,
                mainText: mainText,
                subText: subText,
                size: 310,
                stroke: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: vm.isRunning ? vm.pause : vm.start,
                  icon: Icon(vm.isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(vm.isRunning ? 'Pausar' : 'Iniciar'),
                ),
                const SizedBox(width: 12),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: vm.reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reiniciar'),
                ),
                FilledButton.icon(
                  onPressed: vm.isRunning ? vm.addLap : null,
                  icon: const Icon(Icons.flag),
                  label: const Text('Volta'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text('Nº', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Expanded(
                    child: Text(
                      'Volta',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: vm.laps.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final lap = vm.laps[index];
                  final lapNo = vm.laps.length - index;
                  final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      );
                  return Row(
                    children: [
                      SizedBox(width: 56, child: Text('Nº $lapNo', style: style)),
                      Expanded(
                        child: Text(
                          vm.format(lap.lapTime),
                          style: style,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          vm.format(lap.totalTime),
                          style: style,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
