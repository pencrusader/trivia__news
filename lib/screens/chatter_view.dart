import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/audio_player_bar.dart';

/// Displays market_chatter sections as styled text cards,
/// with a seekable audio player bar at the bottom when audio is available.
class ChatterViewScreen extends StatefulWidget {
  final Map<String, String> chatter;
  final String? audioUrl;

  const ChatterViewScreen({super.key, required this.chatter, this.audioUrl});

  @override
  State<ChatterViewScreen> createState() => _ChatterViewScreenState();
}

class _ChatterViewScreenState extends State<ChatterViewScreen> {
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
    final entries = widget.chatter.entries
        .where((e) => e.key != 'preamble')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('📈 Market Chatter')),
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
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
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
