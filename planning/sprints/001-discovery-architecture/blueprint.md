# Sprint 001 — Discovery & Architecture — Blueprint

## Architecture Overview

See `docs/ARCHITECTURE.md` for full system design. Key points:
- Phone fetches JSON from GitHub raw CDN (not from Pi directly)
- Pi pushes structured JSON bundles via cron `git push`
- Client-side caching (SQLite, 7 days)
- Jina Reader called directly from phone for full articles (Phase 2)

## Data Flow

```
1. Pi cron jobs produce content (already running)
2. NEW: assemble_app_data.py merges outputs into one JSON bundle
3. NEW: push_to_github.sh commits + pushes to pencrusader/trivia__news
4. Flutter app: GET raw.githubusercontent.com/pencrusader/trivia__news/main/briefs/{date}.json
5. App: parse JSON → cache in SQLite → render UI
6. App: images load from CDN URLs directly (cached_network_image)
```

## Component Breakdown

### Pi Scripts (Phase 1, built by news_reporter)

**assemble_app_data.py**
- Reads: today's cron output from `~/.hermes/profiles/news_reporter/cron/output/`
- Reads: `collect_news.py` JSON output
- Merges into app bundle per `docs/DATA_MODEL.md`
- Validates JSON against schema
- Writes to `/home/pencrusader/trivia__news/briefs/{date}.json`
- Updates `/home/pencrusader/trivia__news/latest.json` symlink

**push_to_github.sh**
- `cd /home/pencrusader/trivia__news && git add . && git commit -m "brief $(date +%F)" && git push`
- Runs via cron as no_agent script after assemble_app_data.py

**health_watchdog.sh** (extends existing)
- Add CPU temp, disk, RAM, uptime check
- Write to `/home/pencrusader/trivia__news/health.json`
- Push to GitHub

### Flutter App (Phase 1 MVP)

All files below need to be created:

**Models** (`lib/models/`)
- `brief.dart` — `Brief` with `date`, `sections: List<Section>`
- `article.dart` — `Article` with `title`, `link`, `imageUrl`, `published`, `summary`, `source`
- `health_status.dart` — `HealthStatus` with `cpuTemp`, `diskFree`, `ramFree`, etc.
- All models: `factory fromJson(Map<String, dynamic>)` + `toJson()`

**Services** (`lib/services/`)
- `api_service.dart` — Single class `ApiService`
  - `Future<Brief> fetchBrief(String date)` → GET GitHub raw
  - `Future<HealthStatus> fetchHealth()` → GET health.json
  - Timeout: 10s, retry: 1
  - Error: throw typed exceptions (NetworkException, NotFoundException)

**State** (`lib/state/`)
- `news_provider.dart` — Riverpod providers
  - `briefProvider(date)` → `FutureProvider<Brief>`
  - `healthProvider` → `FutureProvider<HealthStatus>`
  - `availableDatesProvider` → scans cached dates

**Cache** (`lib/services/`)
- `cache_service.dart` — SQLite wrapper
  - `saveBundle(String date, String json)`
  - `getBundle(String date)` → `Brief?`
  - `getAvailableDates()` → `List<String>`
  - `pruneOld(int keepDays = 7)`

**Screens** (`lib/screens/`)
- `home_screen.dart`
  - AppBar: "Hermes News" + health badge
  - DatePickerBar: horizontal scrollable dates, today highlighted
  - ListView of Sections with expandable article grids
  - Pull-to-refresh
  - Empty/loading/error states

- `brief_detail.dart` (stub for Phase 2)
  - Takes a Brief, shows sections with full article lists

**Widgets** (`lib/widgets/`)
- `article_card.dart`
  - `CachedNetworkImage` with placeholder
  - Title (max 2 lines), source + time row
  - Tap handler (stub for article_reader in Phase 2)
  - Missing image → placeholder icon

- `section_header.dart`
  - Emoji icon + section title (e.g., "🌍 Global Macro")
  - Article count badge
  - Expand/collapse chevron

- `date_picker_bar.dart`
  - Horizontal ListView of date chips
  - Today = filled chip, others = outlined
  - Swipe or tap to change date
  - Grey out dates with no data

- `health_badge.dart`
  - Small chip in AppBar
  - Green (all good), Yellow (1+ warnings), Red (Pi offline)
  - Tap to show health detail sheet

## API Contracts

See `docs/API.md`. The Flutter `ApiService` maps directly to those endpoints.

## Third-Party Integrations

| Package | Version | Purpose |
|---------|---------|---------|
| `http` | ^1.2.0 | HTTP client |
| `cached_network_image` | ^3.3.0 | Image loading + disk cache |
| `flutter_riverpod` | ^2.4.0 | State management |
| `sqflite` | ^2.3.0 | SQLite cache |
| `intl` | ^0.19.0 | Date formatting |
| `json_annotation` | ^4.8.0 | JSON serialization |

## pubspec.yaml Template

```yaml
name: hermes_news_reader
description: Flutter news reader for Hermes Pi pipeline
publish_to: 'none'
version: 0.1.0

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  cached_network_image: ^3.3.0
  flutter_riverpod: ^2.4.0
  sqflite: ^2.3.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```
