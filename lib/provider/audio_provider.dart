
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier{

  Duration? totalDuration;
  Duration? position;
  String? audioState;

  /*AudioProvider(){
    initAudio();
  }

  AudioPlayer audioPlayer = AudioPlayer();

  initAudio(){
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalDuration = updatedDuration;
      notifyListeners();
    });

    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      position = updatedPosition;
      notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if(playerState == PlayerState.STOPPED)
        audioState = "Stopped";
      if(playerState==PlayerState.PLAYING)
        audioState = "Playing";
      if(playerState == PlayerState.PAUSED)
        audioState = "Paused";
      notifyListeners();
    });
  }

  playAudio(String url){
    audioPlayer.play(url);
    notifyListeners();
  }


  pauseAudio(){
    audioPlayer.pause();
    notifyListeners();
  }

  repeatAudio(String url){
    audioPlayer.stop().then((value) => audioPlayer.play(url));
  }

  stopAudio(){
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek){
    audioPlayer.seek(durationToSeek);
  }*/



}