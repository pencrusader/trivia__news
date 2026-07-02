# Data Model — Hermes News Reader

## App Bundle JSON (`briefs/YYYY-MM-DD.json`)

This is what the Pi pushes to GitHub and the app fetches.

```json
{
  "version": "1.0",
  "generated_at": "2026-06-29T08:05:00+00:00",
  "generated_by": "Hermes news_reporter / DeepSeek Flash",
  "sources": {
    "brief": "daily_brief cron job (Cloudflare GLM)",
    "chatter": "market_chatter cron job",
    "scout": "multi_platform_scout (Mondays only)",
    "rss": "collect_news.py (17 feeds)"
  },
  "pi_health": {
    "cpu_temp_c": 48.2,
    "disk_free_gb": 22.5,
    "ram_free_mb": 1400,
    "uptime_hours": 72,
    "last_cron_run": "2026-06-29T08:00:05+00:00"
  },
  "brief": {
    "date": "2026-06-29",
    "sections": [
      {
        "id": "global_macro",
        "title": "🌍 Global Macro",
        "summary": "Consolidated summary text from GLM...",
        "headlines": [
          "Comcast jumps 9% on broadband growth outlook",
          "ECB signals rate cut in September"
        ],
        "articles": [
          {
            "title": "Comcast jumps 9% on broadband growth outlook",
            "link": "https://finance.yahoo.com/news/comcast-broadband-growth-...",
            "image_url": "https://s.yimg.com/.../photo.jpg",
            "published": "2026-06-29T15:22:15+00:00",
            "summary": "Comcast shares surged 9% after the company raised...",
            "source": "Yahoo Finance"
          }
        ]
      }
    ]
  },
  "chatter": {
    "date": "2026-06-29",
    "summary": "Evening market sentiment analysis...",
    "sections": []
  },
  "scout": null
}
```

## Entities

### Brief
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| date | ISO date | Yes | Brief date |
| sections | Section[] | Yes | 4-5 sections (global_macro, us_domestic, business, tech, science) |

### Section
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | Yes | Section slug |
| title | string | Yes | Display title with emoji |
| summary | string | Yes | GLM-consolidated summary (markdown, <500 chars) |
| headlines | string[] | Yes | Top headline text only |
| articles | Article[] | No | RSS articles with full metadata |

### Article
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | string | Yes | Article headline |
| link | string | Yes | Original article URL |
| image_url | string | No | CDN image URL (can be null) |
| published | ISO 8601 | Yes | Publication timestamp |
| summary | string | No | Short description from RSS feed |
| source | string | Yes | Publication name |

### HealthStatus
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| cpu_temp_c | float | No | CPU temperature |
| disk_free_gb | float | No | Free disk space |
| ram_free_mb | int | No | Free memory |
| uptime_hours | int | No | System uptime |
| last_cron_run | ISO 8601 | No | Most recent cron execution |

## Cache Schema (SQLite on Phone)

```sql
CREATE TABLE cached_bundles (
  date TEXT PRIMARY KEY,
  json_data TEXT NOT NULL,       -- Full JSON blob
  fetched_at INTEGER NOT NULL    -- Unix timestamp
);

CREATE TABLE read_articles (
  article_url TEXT PRIMARY KEY,
  opened_at INTEGER NOT NULL
);
```

## Validation Rules
- `brief.date` must match the filename date
- `sections` array must have at least 1 entry
- `articles[].link` must be a valid URL
- `image_url` is nullable — app must handle missing images gracefully
- `pi_health` is optional (may be absent if Pi monitoring isn't configured)
- `scout` is null on non-Monday dates
