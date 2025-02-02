import 'package:flutter/material.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/stream/components/controls/curren_duration_player.dart';
import 'package:jellyflut/screens/stream/components/controls/current_position_player.dart';
import 'package:jellyflut/screens/stream/components/controls/fullscreen_button.dart';
import 'package:jellyflut/screens/stream/components/controls/pip_button.dart';
import 'package:jellyflut/screens/stream/components/controls/play_pause_button.dart';
import 'package:jellyflut/screens/stream/components/controls/video_player_progress_bar.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';
import 'package:jellyflut/screens/stream/components/player_infos/transcode_state.dart';
import 'package:universal_io/io.dart';

import '../controls/audio_button_selector.dart';
import '../controls/backward_button.dart';
import '../controls/chapter_button.dart';
import '../controls/forward_button.dart';
import '../controls/subtitle_button_selector.dart';
import '../player_infos/subtitle_box.dart';

class CommonControlsPhone extends StatefulWidget {
  final bool isComputer;

  const CommonControlsPhone({super.key, this.isComputer = false});

  @override
  State<CommonControlsPhone> createState() => _CommonControlsPhoneState();
}

class _CommonControlsPhoneState extends State<CommonControlsPhone> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black38,
      child: LayoutBuilder(
          builder: (c, cc) => Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(child: body()),
                  Positioned.fill(
                    top: cc.maxHeight * 0.6,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SubtitleBox()),
                  ),
                ],
              )),
    );
  }

  Widget body() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TopRow())),
        const Expanded(child: Controls()),
        const Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: BottomRow(),
        ))
      ],
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [const ItemTitle(), const ItemParentTitle()],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PipButton(),
              const ChapterButton(),
              const SubtitleButtonSelector(),
              const AudioButtonSelector(),
              const TranscodeState()
            ],
          )
        ]);
  }

  Widget backButton() {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return Row(children: [
        const SelectableBackButton(shadow: true),
        const SizedBox(width: 12)
      ]);
    }
    return const SizedBox();
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const BackwardButton(size: 42),
        const SizedBox(width: 12),
        const PlayPauseButton(size: 42),
        const SizedBox(width: 12),
        const ForwardButton(size: 42),
      ],
    );
  }
}

class BottomRow extends StatelessWidget {
  const BottomRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CurrentPositionPlayer(),
              const Text('/'),
              const CurrentDurationPlayer(),
              const Spacer(),
              if (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
                const FullscreenButton()
            ]),
        const VideoPlayerProgressBar(barHeight: 4, thumbRadius: 8),
        const SizedBox(height: 24),
      ],
    );
  }
}
