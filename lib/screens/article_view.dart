import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class ArticleViewScreen extends StatelessWidget {
  final Article article;

  const ArticleViewScreen({super.key, required this.article});

  Future<void> _openInBrowser() async {
    if (article.link.isNotEmpty) {
      final uri = Uri.tryParse(article.link);
      if (uri != null) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.network(
                  article.imageUrl!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 64),
                    ),
                  ),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 220,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.source, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        article.source,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (article.published != null &&
                          article.published!.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          article.published!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    article.summary.isNotEmpty
                        ? article.summary
                        : 'No summary available.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (article.link.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _openInBrowser,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open in Browser'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
