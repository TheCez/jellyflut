import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class BackwardButton extends StatefulWidget {
  final Duration duration;
  final double? size;
  const BackwardButton(
      {super.key, this.duration = const Duration(seconds: 10), this.size});

  @override
  State<BackwardButton> createState() => _BackwardButtonState();
}

class _BackwardButtonState extends State<BackwardButton> {
  late final StreamingProvider streamingProvider;

  double? get size => widget.size;

  @override
  void initState() {
    streamingProvider = StreamingProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: backward,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.fast_rewind,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }

  void backward() {
    final currentDuration =
        streamingProvider.commonStream!.getCurrentPosition();
    final seekToDuration =
        (currentDuration ?? widget.duration) - widget.duration;
    streamingProvider.commonStream!.seekTo(seekToDuration);
  }
}
