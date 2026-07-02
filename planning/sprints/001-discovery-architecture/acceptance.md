# Sprint 001 — Acceptance Criteria

## What "Done" Means
The Builder must satisfy ALL of these.

### Functional
- [ ] AC001: App launches and fetches today's brief from GitHub raw without crashing
- [ ] AC002: Home screen renders sections with expandable article cards
- [ ] AC003: Article cards show image (with placeholder if null), title, source, time
- [ ] AC004: Date picker bar shows available dates, switches between them
- [ ] AC005: Pull-to-refresh reloads data and updates UI
- [ ] AC006: Offline: last cached data displays with "Updated X min ago" indicator
- [ ] AC007: Health badge shows green/yellow/red based on pi_health JSON
- [ ] AC008: Missing/broken image shows placeholder, does NOT crash
- [ ] AC009: Empty section (no articles) hides gracefully
- [ ] AC010: Network timeout shows cached data, not error screen

### Non-Functional
- [ ] ACNF001: Cold start → home screen visible in <2 seconds (with cache)
- [ ] ACNF002: JSON parse failure → app shows cached data, logs error, no crash
- [ ] ACNF003: Bundle >100KB → app handles without UI freeze

### Test Coverage
- [ ] Unit tests for all model `fromJson`/`toJson` methods
- [ ] Unit tests for `ApiService` with mocked HTTP responses
- [ ] Widget tests for `article_card` with and without image
- [ ] Widget tests for `date_picker_bar` with 0, 1, and 7 dates

### Documentation
- [ ] `README.md` updated with quick start instructions
- [ ] `docs/API.md` reflects actual endpoints (already done)

## How to Verify
```bash
cd hermes-news-reader
flutter analyze          # No errors
flutter test             # All green
flutter build apk --debug  # Builds without errors
```

## Test Data
Use this minimal JSON for testing (save as `test_bundle.json`):
```json
{
  "version": "1.0",
  "generated_at": "2026-06-29T08:05:00Z",
  "brief": {
    "date": "2026-06-29",
    "sections": [
      {
        "id": "global_macro",
        "title": "🌍 Global Macro",
        "summary": "Markets rallied today as...",
        "headlines": ["Test headline 1", "Test headline 2"],
        "articles": [
          {
            "title": "Test Article With Image",
            "link": "https://example.com",
            "image_url": "https://picsum.photos/400/200",
            "published": "2026-06-29T15:22:15Z",
            "summary": "A short summary.",
            "source": "Test Source"
          },
          {
            "title": "Test Article Without Image",
            "link": "https://example.com/2",
            "image_url": null,
            "published": "2026-06-29T14:00:00Z",
            "summary": "No image available.",
            "source": "Another Source"
          }
        ]
      }
    ]
  },
  "pi_health": {
    "cpu_temp_c": 48.2,
    "disk_free_gb": 22.5,
    "ram_free_mb": 1400,
    "uptime_hours": 72,
    "last_cron_run": "2026-06-29T08:00:05Z"
  }
}
```
