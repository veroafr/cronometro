# Cronometro (Flutter)

Cronômetro de voltas com MVVM, acessibilidade e notificações locais.

## Funcionalidades
- Iniciar / Pausar / Reiniciar cronômetro
- Registrar voltas (lista mostra **tempo da volta** e **tempo total**)
- Acessibilidade: `Semantics`, botões rotulados, bom contraste, fontes ampliadas
- Notificações:
  - Persistente enquanto o cronômetro está rodando
  - Notificação por volta registrada (tempo da volta + total)
  - Lembrete após pausa > 10s sugerindo retomar

## Arquitetura
- **MVVM** com `provider`
  - `models/` (`Lap`)
  - `viewmodels/` (`StopwatchViewModel`)
  - `views/` (`StopwatchPage`)
  - `services/` (`NotificationService`)

## Executar
```bash
flutter pub get
flutter run
```
> Se faltar a pasta de plataforma (android/ios), rode `flutter create .` uma vez.

## Permissões
Android 13+: `POST_NOTIFICATIONS` (o plugin solicitará em tempo de execução).

## Vídeo
[![Mira el video](https://img.youtube.com/vi/eicSrLuzb_M/hqdefault.jpg)](https://www.youtube.com/watch?v=eicSrLuzb_M)
