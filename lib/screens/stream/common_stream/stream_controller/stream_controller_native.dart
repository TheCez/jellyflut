import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';

import '../common_stream_BP.dart';
import '../common_stream_VLC.dart';
import '../common_stream_VLC_computer.dart';

CommonStream parse(dynamic controller) {
  if (controller is VlcPlayerController) {
    return _parseVLCController(vlcPlayerController: controller);
  } else if (controller is BetterPlayerController) {
    return _parseBetterPlayerController(betterPlayerController: controller);
  } else if (controller is Player) {
    return _parseVlcComputerController(player: controller);
  }
  throw UnsupportedError(
      'No suitable player controller implementation was found.');
}

CommonStream _parseVLCController(
    {required VlcPlayerController vlcPlayerController}) {
  final commonStreamVLC =
      CommonStreamVLC(vlcPlayerController: vlcPlayerController);
  return CommonStream(
      pause: vlcPlayerController.pause,
      play: vlcPlayerController.play,
      isPlaying: () => vlcPlayerController.value.isPlaying,
      seekTo: vlcPlayerController.seekTo,
      duration: () => vlcPlayerController.value.duration,
      bufferingDuration: commonStreamVLC.getBufferingDurationVLC,
      currentPosition: () => vlcPlayerController.value.position,
      isInit: () => vlcPlayerController.value.isInitialized,
      hasPip: Future.value(false),
      pip: () => throw ('Not supported on VLC player'),
      getSubtitles: commonStreamVLC.getSubtitles,
      setSubtitle: (Subtitle subtitle) =>
          vlcPlayerController.setSpuTrack(subtitle.index),
      disableSubtitles: () => vlcPlayerController.setSpuTrack(-1),
      getAudioTracks: commonStreamVLC.getAudioTracks,
      setAudioTrack: (audioTrack) => commonStreamVLC.setAudioTrack(audioTrack),
      positionStream: commonStreamVLC.positionStream(),
      durationStream: commonStreamVLC.durationStream(),
      isPlayingStream: commonStreamVLC.playingStateStream(),
      enterFullscreen: () => {},
      exitFullscreen: () => {},
      toggleFullscreen: () => {},
      dispose: commonStreamVLC.stopPlayer,
      controller: vlcPlayerController);
}

CommonStream _parseBetterPlayerController(
    {required BetterPlayerController betterPlayerController}) {
  final commonStreamBP =
      CommonStreamBP(betterPlayerController: betterPlayerController);
  return CommonStream(
      pause: betterPlayerController.pause,
      play: betterPlayerController.play,
      isPlaying: () =>
          betterPlayerController.videoPlayerController!.value.isPlaying,
      seekTo: betterPlayerController.seekTo,
      duration: () =>
          betterPlayerController.videoPlayerController?.value.duration,
      bufferingDuration: commonStreamBP.getBufferingDurationBP,
      currentPosition: () =>
          betterPlayerController.videoPlayerController?.value.position,
      isInit: () => betterPlayerController.isVideoInitialized() ?? false,
      hasPip: betterPlayerController.isPictureInPictureSupported(),
      pip: () => betterPlayerController.enablePictureInPicture(
          betterPlayerController.betterPlayerGlobalKey!),
      getSubtitles: commonStreamBP.getSubtitles,
      setSubtitle: commonStreamBP.setSubtitle,
      disableSubtitles: commonStreamBP.disableSubtitles,
      getAudioTracks: commonStreamBP.getAudioTracks,
      setAudioTrack: commonStreamBP.setAudioTrack,
      positionStream: commonStreamBP.positionStream(),
      durationStream: commonStreamBP.durationStream(),
      isPlayingStream: commonStreamBP.playingStateStream(),
      enterFullscreen: () => {},
      exitFullscreen: () => {},
      toggleFullscreen: () => {},
      dispose: commonStreamBP.stopPlayer,
      controller: betterPlayerController);
}

CommonStream _parseVlcComputerController({required Player player}) {
  final commonStreamVLCComputer = CommonStreamVLCComputer(player: player);
  return CommonStream(
      pause: commonStreamVLCComputer.pause,
      play: commonStreamVLCComputer.play,
      isPlaying: () => player.playback.isPlaying,
      seekTo: commonStreamVLCComputer.seek,
      duration: () => player.position.duration,
      bufferingDuration: () => Duration(seconds: 0),
      currentPosition: () => player.position.position,
      isInit: () => true,
      hasPip: Future.value(false),
      pip: commonStreamVLCComputer.pip,
      getSubtitles: commonStreamVLCComputer.getSubtitles,
      setSubtitle: commonStreamVLCComputer.setSubtitle,
      disableSubtitles: commonStreamVLCComputer.disableSubtitles,
      getAudioTracks: commonStreamVLCComputer.getAudioTracks,
      setAudioTrack: commonStreamVLCComputer.setAudioTrack,
      enterFullscreen: commonStreamVLCComputer.enterFullscreen,
      exitFullscreen: commonStreamVLCComputer.exitFullscreen,
      toggleFullscreen: commonStreamVLCComputer.toggleFullscreen,
      positionStream: commonStreamVLCComputer.positionStream(),
      durationStream: commonStreamVLCComputer.durationStream(),
      isPlayingStream: commonStreamVLCComputer.playingStateStream(),
      dispose: commonStreamVLCComputer.stopPlayer,
      controller: player);
}
