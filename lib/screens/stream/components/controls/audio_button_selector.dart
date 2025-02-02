import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/media_type.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class AudioButtonSelector extends StatefulWidget {
  const AudioButtonSelector({super.key});

  @override
  State<AudioButtonSelector> createState() => _AudioButtonSelectorState();
}

class _AudioButtonSelectorState extends State<AudioButtonSelector> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late final GlobalKey<PopupMenuButtonState<AudioTrack>> _popupMenuButtonKey;
  late int audioSelectedIndex;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        skipTraversal: true);
    streamingProvider = StreamingProvider();
    audioSelectedIndex = streamingProvider.selectedAudioTrack?.index ?? -1;
    _popupMenuButtonKey = GlobalKey();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
        shape: CircleBorder(),
        child: changeAudioTrack(context));
  }

  Widget changeAudioTrack(BuildContext context) {
    return ExcludeFocus(
        child: IgnorePointer(
            child: FutureBuilder<List<AudioTrack>>(
      future: streamingProvider.getAudioTracks(),
      builder: (context, snapshot) => PopupMenuButton<AudioTrack>(
          key: _popupMenuButtonKey,
          icon: Icon(
            Icons.audiotrack,
            color: Colors.white,
          ),
          tooltip: 'select_audio_source'.tr(),
          onSelected: (AudioTrack audioTrack) => setAudioTrack(audioTrack),
          itemBuilder: (context) {
            if (snapshot.hasData) {
              return _audioTracksListTile(snapshot.data!);
            }
            return <PopupMenuEntry<AudioTrack>>[];
          }),
    )));
  }

  List<PopupMenuEntry<AudioTrack>> _audioTracksListTile(
      List<AudioTrack> audioTracks) {
    final list = <PopupMenuEntry<AudioTrack>>[];

    // TITLE
    list.add(PopupMenuItem(child: Text('select_audio_source'.tr())));

    if (audioTracks.isEmpty) {
      list.add(
          PopupMenuItem(enabled: false, child: Text('no_audio_source'.tr())));
      return list;
    }

    // If audio tracks list is not empty the we show disabled button at start of list
    final disabledAudioTrack =
        AudioTrack(index: -1, name: 'default'.tr(), mediaType: MediaType.LOCAL);
    list.add(
      CheckedPopupMenuItem(
        value: disabledAudioTrack,
        checked: isSelected(disabledAudioTrack),
        child: Text(
          'default'.tr(),
        ),
      ),
    );

    // LOCAL AUDIO TRACKS
    final localAudioTracks = audioTracks
        .where((element) => element.mediaType == MediaType.LOCAL)
        .toList();
    list.add(PopupMenuDivider(height: 10));
    list.add(listItemTitle(
        child: Text(
      'embeded_audio_tracks'.tr(),
      style: Theme.of(context).textTheme.bodyText2,
    )));

    if (localAudioTracks.isEmpty) {
      list.add(PopupMenuItem(
          enabled: false,
          child: Align(
              alignment: Alignment.center,
              child: Text('no_audio_source'.tr()))));
    } else {
      for (var index = 0; index < localAudioTracks.length; index++) {
        final audioTrack = localAudioTracks.elementAt(index);
        list.add(
          CheckedPopupMenuItem(
            value: audioTrack,
            checked: audioTrack.index == audioSelectedIndex,
            child: Text(audioTrack.name),
          ),
        );
      }
    }

    // REMOTE AUDIO TRACKS
    list.add(PopupMenuDivider(height: 10));
    list.add(
      listItemTitle(
          child: Text(
        'remote_audio_tracks'.tr(),
        style: Theme.of(context).textTheme.bodyText2,
      )),
    );

    final remoteAudioTracks = audioTracks
        .where((element) => element.mediaType == MediaType.REMOTE)
        .toList();
    if (remoteAudioTracks.isEmpty) {
      list.add(
          PopupMenuItem(enabled: false, child: Text('no_audio_source'.tr())));
    } else {
      for (var index = 0; index < remoteAudioTracks.length; index++) {
        final audioTrack = remoteAudioTracks.elementAt(index);
        list.add(CheckedPopupMenuItem(
          value: audioTrack,
          checked: audioTrack.index == audioSelectedIndex,
          child: Text(audioTrack.name),
        ));
      }
    }

    return list;
  }

  PopupMenuEntry<AudioTrack> listItemTitle({required Widget child}) {
    return PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 4),
        height: 30,
        enabled: false,
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: ColorUtil.darken(
                    Theme.of(context).colorScheme.background, 0.1)),
            child: child));
  }

  bool isSelected(AudioTrack audioTrack) {
    return audioSelectedIndex == audioTrack.index;
  }

  void setAudioTrack(AudioTrack audioTrack) async {
    audioSelectedIndex = audioTrack.index;
    streamingProvider.setAudioStreamIndex(audioTrack);

    // We tell the player to show subtitles only if it's local
    // Via remote we use our own code for compatitbility
    if (audioTrack.mediaType == MediaType.LOCAL) {
      await streamingProvider.commonStream!.setAudioTrack(audioTrack);
    }
  }
}
