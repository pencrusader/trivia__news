import 'package:flutter/material.dart';
import '../models/brief.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'article_view.dart';

class BriefDetailScreen extends StatelessWidget {
  final Brief brief;
  final String sectionName;

  const BriefDetailScreen({
    super.key,
    required this.brief,
    required this.sectionName,
  });

  List<Article> _filteredArticles() {
    return brief.articles
        .where((a) => a.section == sectionName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final articles = _filteredArticles();
    return Scaffold(
      appBar: AppBar(title: Text(sectionName)),
      body: articles.isEmpty
          ? const Center(
              child: Text(
                'No articles in this section.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleViewScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
