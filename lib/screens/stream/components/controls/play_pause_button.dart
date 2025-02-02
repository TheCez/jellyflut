import 'package:flutter/material.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class PlayPauseButton extends StatefulWidget {
  final double? size;
  const PlayPauseButton({super.key, this.size});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late final StreamingProvider streamingProvider;
  late final VoidCallback listener;

  double? get size => widget.size;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: streamingProvider.commonStream?.isPlaying(),
      stream: streamingProvider.commonStream!.getPlayingStateStream(),
      builder: (context, isPlayingSnapshot) => OutlinedButtonSelector(
          onPressed: () => isPlayingSnapshot.data ?? false
              ? streamingProvider.pause()
              : streamingProvider.play(),
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isPlayingSnapshot.data ?? false ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: size,
            ),
          )),
    );
  }
}
