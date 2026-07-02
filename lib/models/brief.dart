import 'article.dart';

class Brief {
  final String date;
  final Map<String, List<String>> sections;
  final List<Article> articles;
  final Map<String, dynamic>? meta;
  final Map<String, String>? chatter;
  final Map<String, String>? audio;
  final Map<String, String>? narrative;

  Brief({
    required this.date,
    required this.sections,
    required this.articles,
    this.meta,
    this.chatter,
    this.audio,
    this.narrative,
  });

  factory Brief.fromJson(Map<String, dynamic> json) {
    final sectionsRaw = json['sections'] as Map<String, dynamic>? ?? {};
    final Map<String, List<String>> sections = {};
    sectionsRaw.forEach((key, value) {
      sections[key] = (value as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    });

    final articlesRaw = json['articles'] as List<dynamic>? ?? [];
    final articles = articlesRaw
        .map((e) => Article.fromJson(e as Map<String, dynamic>))
        .toList();

    final chatterRaw = json['chatter'] as Map<String, dynamic>?;
    final Map<String, String>? chatter = chatterRaw?.map(
      (k, v) => MapEntry(k, v.toString()),
    );

    return Brief(
      date: json['date'] as String? ?? '',
      sections: sections,
      articles: articles,
      meta: json['meta'] as Map<String, dynamic>?,
      chatter: chatter,
      audio: (json['audio'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v.toString()),
      ),
      narrative: (json['narrative'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v.toString()),
      ),
    );
  }
}
