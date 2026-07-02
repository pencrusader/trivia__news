import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'services/github_api.dart';
import 'models/brief.dart';
import 'models/health.dart';
import 'widgets/article_card.dart';
import 'widgets/section_header.dart';
import 'widgets/health_badge.dart';
import 'screens/brief_detail.dart';
import 'screens/chatter_view.dart';
import 'screens/narrative_view.dart';
import 'widgets/audio_player_bar.dart';

void main() {
  runApp(const HermesNewsReaderApp());
}

class HermesNewsReaderApp extends StatelessWidget {
  const HermesNewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<GithubApi>(
      create: (_) => GithubApi(),
      dispose: (_, api) => api.dispose(),
      child: MaterialApp(
        title: 'Hermes News Reader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Brief? _brief;
  PiHealth? _health;
  bool _loading = true;
  String? _error;
  String _lastUpdated = '';
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    final api = context.read<GithubApi>();
    try {
      final brief = await api.fetchLatestBrief();
      PiHealth health;
      try { health = await api.fetchHealth(); } catch (_) {
        health = PiHealth(cpuTempC: 0, diskFreeGb: 0, ramFreeMb: 0,
            uptimeHours: 0, lastBriefStatus: 'unknown', timestamp: '');
      }
      if (!mounted) return;
      setState(() {
        _brief = brief;
        _health = health;
        _loading = false;
        _lastUpdated = _nowString();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Widget _buildChatterCard(BuildContext context, Brief brief) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: const Icon(Icons.show_chart, size: 32),
        title: const Text('📈 Market Chatter',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Social sentiment, movers, next-day setup'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatterViewScreen(
                chatter: brief.chatter!,
                audioUrl: brief.audio?['chatter'],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNarrativeCard(BuildContext context, Brief brief) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: ListTile(
        leading: const Icon(Icons.menu_book, size: 32),
        title: const Text('📻 Morning Brief',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Today\'s story — narrated with audio'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NarrativeViewScreen(
                narrative: brief.narrative!,
                audioUrl: brief.audio?['daily_brief'],
              ),
            ),
          );
        },
      ),
    );
  }

  String _nowString() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hermes News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: HealthBadge(
              isHealthy: _health != null &&
                  _health!.cpuTempC < 80 &&
                  _health!.diskFreeGb > 1.0,
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _brief?.audio?['daily_brief'] != null
          ? AudioPlayerBar(player: _audioPlayer)
          : null,
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Failed to load brief', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final brief = _brief!;
    final sectionNames = brief.sections.keys.toList();
    final hasNarrative = brief.narrative != null;
    final hasChatter = brief.chatter != null;
    final topCards = (hasNarrative ? 1 : 0) + (hasChatter ? 1 : 0);

    if (sectionNames.isEmpty && topCards == 0) {
      return const Center(child: Text('No sections available.', style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sectionNames.length + topCards,
            itemBuilder: (context, index) {
              // Narrative card first, then chatter, then sections
              if (hasNarrative && hasChatter) {
                if (index == 0) return _buildNarrativeCard(context, brief);
                if (index == 1) return _buildChatterCard(context, brief);
              } else if (hasNarrative && index == 0) {
                return _buildNarrativeCard(context, brief);
              } else if (hasChatter && index == 0) {
                return _buildChatterCard(context, brief);
              }

              final adjustedIndex = index - topCards;
              final sectionName = sectionNames[adjustedIndex];
              final sectionRefs = brief.sections[sectionName] ?? [];
              final sectionArticles = brief.articles
                  .where((a) => a.section == sectionName)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    name: sectionName,
                    count: sectionArticles.length,
                  ),
                  ...sectionArticles.take(3).map(
                        (article) => ArticleCard(
                          article: article,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BriefDetailScreen(
                                  brief: brief,
                                  sectionName: sectionName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  if (sectionArticles.length > 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BriefDetailScreen(
                                brief: brief,
                                sectionName: sectionName,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View all ${sectionArticles.length} articles →',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          );  // RefreshIndicator
  }
}

// trigger pipeline

// trigger v2

// trigger v3

// trigger v5

// trigger v6

// trigger v7
