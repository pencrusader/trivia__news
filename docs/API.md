# API Reference — Hermes News Reader

## Base URL
```
https://raw.githubusercontent.com/pencrusader/trivia__news/main
```

## Authentication
None. Public repo, read-only data. All content is non-sensitive news aggregation.

## Endpoints

### GET /briefs/{YYYY-MM-DD}.json
Fetch a specific day's news bundle.

**Response:** See `docs/DATA_MODEL.md` → App Bundle JSON

**Error:** 404 if date not found (no brief generated that day)

---

### GET /latest.json
Redirect / symlink to today's latest bundle. Always returns the freshest data.

**Response:** Same as `/briefs/{today}.json`

**Error:** 404 if no brief generated yet today (before 8:05 AM)

---

### GET /health.json
Pi system health snapshot (updated every 30 min by cron watchdog).

**Response:**
```json
{
  "timestamp": "2026-06-29T08:30:00+00:00",
  "cpu_temp_c": 48.2,
  "disk_free_gb": 22.5,
  "ram_free_mb": 1400,
  "uptime_hours": 72,
  "cron_status": "ok",
  "last_brief": "2026-06-29T08:05:00+00:00",
  "last_chatter": "2026-06-28T18:15:00+00:00"
}
```

---

### External: Jina Reader API
The Flutter app calls Jina Reader directly for full article text. NOT proxied through Pi.

**URL:** `https://r.jina.ai/{article_url}`

**Usage:** When user taps "Read Full Article", app sends the original article URL to Jina Reader. Returns clean markdown.

**Rate limit:** 200 requests/hour (Jina free tier). Sufficient for single-user reading.

## Error Handling (App Side)

| HTTP Status | App Behavior |
|-------------|--------------|
| 200 | Parse JSON, update cache, show data |
| 304 | Use cached data (if using ETags) |
| 404 | Show "No brief today yet" |
| Timeout / no network | Show cached data + "Updated X min ago" badge |
| Any 5xx | Show cached data + "GitHub unavailable" toast |
