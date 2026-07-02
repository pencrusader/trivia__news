import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/audio_player_bar.dart';

/// Displays the daily_brief narrative sections as styled cards,
/// with a seekable audio player bar at the bottom.
class NarrativeViewScreen extends StatefulWidget {
  final Map<String, String> narrative;
  final String? audioUrl;

  const NarrativeViewScreen({super.key, required this.narrative, this.audioUrl});

  @override
  State<NarrativeViewScreen> createState() => _NarrativeViewScreenState();
}

class _NarrativeViewScreenState extends State<NarrativeViewScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAudio() {
    if (widget.audioUrl != null && !_audioPlayer.playing) {
      _audioPlayer.setUrl(widget.audioUrl!);
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = widget.narrative.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('📻 Morning Brief')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.value,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.audioUrl != null
          ? AudioPlayerBar(player: _audioPlayer)
          : null,
      floatingActionButton: widget.audioUrl != null
          ? FloatingActionButton.small(
              onPressed: _startAudio,
              child: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
