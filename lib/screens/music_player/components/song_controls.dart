import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/music_player/components/next_button.dart';
import 'package:jellyflut/screens/music_player/components/prev_button.dart';

class SongControls extends StatefulWidget {
  const SongControls({super.key});

  @override
  State<SongControls> createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  late final MusicProvider musicProvider;
  late ThemeData theme;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrevButton(),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: primary,
                boxShadow: shadows,
                borderRadius: borderRadiusButton,
              ),
              child: StreamBuilder<bool?>(
                stream: musicProvider.isPlaying(),
                builder: (context, snapshot) => OutlinedButtonSelector(
                    onPressed: () => isPlaying(snapshot.data)
                        ? musicProvider.pause()
                        : musicProvider.play(),
                    shape: const RoundedRectangleBorder(
                      borderRadius: borderRadiusButton,
                    ),
                    child: Icon(
                      isPlaying(snapshot.data) ? Icons.pause : Icons.play_arrow,
                      color: onPrimary,
                      size: 42,
                    )),
              )),
        ),
        NextButton()
      ],
    );
  }

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }
}
