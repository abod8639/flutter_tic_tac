import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

class SoundService {
  late BehaviorSubject<bool> _enableSound$;
  BehaviorSubject<bool> get enableSound$ => _enableSound$;
  final AudioPlayer _player = AudioPlayer();

  SoundService() {
    _enableSound$ = BehaviorSubject<bool>.seeded(true);
  }

  void playSound(String sound) async {
    bool isSoundEnabled = _enableSound$.value;
    if (isSoundEnabled) {
      await _player.play(AssetSource("$sound.mp3"));
    }
  }

  void dispose() {
    _player.dispose();
    _enableSound$.close();
  }
}
