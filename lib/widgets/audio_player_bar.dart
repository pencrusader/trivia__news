import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// A compact audio player bar with rewind/forward, seekable progress bar,
/// and current/total time display. Streams from a URL via just_audio.
class AudioPlayerBar extends StatefulWidget {
  final AudioPlayer player;

  const AudioPlayerBar({super.key, required this.player});

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _seekRelative(double seconds) async {
    final dur = widget.player.duration ?? Duration.zero;
    var newPos = widget.player.position + Duration(seconds: seconds.toInt());
    if (newPos < Duration.zero) newPos = Duration.zero;
    if (newPos > dur) newPos = dur;
    await widget.player.seek(newPos);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final playing = state?.playing ?? false;
        final processing = state?.processingState == ProcessingState.loading ||
            state?.processingState == ProcessingState.buffering;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                StreamBuilder<Duration>(
                  stream: widget.player.positionStream,
                  builder: (context, posSnapshot) {
                    final position = posSnapshot.data ?? Duration.zero;
                    final duration = widget.player.duration ?? Duration.zero;
                    return Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            min: 0,
                            max: duration.inMilliseconds.toDouble().clamp(0, double.infinity),
                            value: position.inMilliseconds
                                .toDouble()
                                .clamp(0, duration.inMilliseconds.toDouble()),
                            onChanged: (v) {
                              widget.player.seek(Duration(milliseconds: v.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fmt(position),
                                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                              Text(_fmt(duration),
                                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      tooltip: 'Rewind 10s',
                      onPressed: () => _seekRelative(-10),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      iconSize: 40,
                      icon: processing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                      tooltip: playing ? 'Pause' : 'Play',
                      onPressed: () {
                        if (playing) {
                          widget.player.pause();
                        } else {
                          widget.player.play();
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      tooltip: 'Forward 10s',
                      onPressed: () => _seekRelative(10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
