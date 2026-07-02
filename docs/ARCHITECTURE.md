# Architecture — Hermes News Reader

## System Overview

```
Pi 4B: cron jobs → assemble_app_data.py → JSON → git push → GitHub
                                                           │
Phone: Flutter app ← HTTP GET ← raw.githubusercontent.com/pencrusader/trivia__news
                                                           │
Full articles: Flutter app ← Jina Reader API (direct call)
```

The Pi is a **content generator**, NOT a server. It pushes structured JSON to GitHub. The phone fetches from GitHub's global CDN. No direct Pi↔Phone connection needed.

## Component Tree

```
Flutter App
├── lib/
│   ├── main.dart                    # App entry, MaterialApp, theme
│   ├── config/
│   │   └── api_config.dart          # Base URLs, endpoints
│   ├── models/
│   │   ├── brief.dart               # Brief model (date, sections)
│   │   ├── article.dart             # Article model (title, image, link, source)
│   │   └── health_status.dart       # Pi health model
│   ├── services/
│   │   └── api_service.dart         # HTTP client → GitHub raw
│   ├── state/
│   │   └── news_provider.dart       # Riverpod: current brief, loading, error
│   ├── screens/
│   │   ├── home_screen.dart         # Today's brief + latest feeds
│   │   ├── brief_detail.dart        # One brief with section drill-down
│   │   ├── article_reader.dart      # Full article via Jina Reader
│   │   ├── feed_browser.dart        # Browse RSS articles by section
│   │   ├── search_screen.dart       # Full-text search (client-side)
│   │   └── settings_screen.dart     # Pi address, refresh, cache
│   └── widgets/
│       ├── article_card.dart        # Image + title + source card
│       ├── section_header.dart      # Section label with icon
│       ├── date_picker_bar.dart     # Horizontal swipeable date strip
│       └── health_badge.dart        # Pi status indicator
└── pubspec.yaml
```

## Data Flow

1. **Pi pushes** → `git push` JSON files to `pencrusader/trivia__news/main/`
2. **Phone fetches** → `GET raw.githubusercontent.com/pencrusader/trivia__news/main/briefs/YYYY-MM-DD.json`
3. **Phone caches** → SQLite local DB, 7-day retention
4. **Offline fallback** → Show cached data with "Updated X min ago"
5. **Images** → Loaded directly from CDN URLs (Yahoo, Ars, CNBC etc.) via `cached_network_image`
6. **Full articles** → Phone calls Jina Reader API directly: `GET https://r.jina.ai/{article_url}`

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| GitHub as data store (not Flask on Pi) | Zero Pi server management, global CDN, free, works anywhere |
| Client-side search (not API) | <1000 articles total, instant on phone CPU, no server needed |
| Jina Reader direct from phone | Pi doesn't need to proxy; Jina is a public API |
| Riverpod over Provider | Type-safe, no BuildContext dependency, better for testing |
| SQLite cache 7 days | Small footprint, covers typical reading patterns |
| No auth for MVP | Public repo only, all data is news (non-sensitive) |
| JSON bundles <100KB | Summary text only, not full articles. Images are external URLs |
