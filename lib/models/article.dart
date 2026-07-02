class Article {
  final String title;
  final String link;
  final String? imageUrl;
  final String source;
  final String? published;
  final String summary;

  final String? section;

  Article({
    required this.title,
    required this.link,
    this.imageUrl,
    required this.source,
    this.published,
    this.summary = '',
    this.section,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      source: json['source'] as String? ?? '',
      published: json['published'] as String?,
      summary: json['summary'] as String? ?? '',
      section: json['section'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'imageUrl': imageUrl,
      'source': source,
      'published': published,
      'summary': summary,
    };
  }
}
