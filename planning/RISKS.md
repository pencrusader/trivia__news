# Risk Register — Hermes News Reader

| ID | Risk | Likelihood | Impact | Mitigation | Owner |
|----|------|------------|--------|------------|-------|
| R001 | GitHub raw CDN latency >2s in India | Med | Low | Cache aggressively on phone; fallback to stale data | App |
| R002 | GitHub API rate limit on raw files | Low | Med | Cache on phone; ~100 req/day is far below limits | App |
| R003 | collect_news.py output shape changes | Med | High | Pi script validates JSON against schema before push; app handles unknown fields gracefully | Pi |
| R004 | Jina Reader returns 429 (rate limit) | Low | Low | Show "Article unavailable, open in browser" fallback | App |
| R005 | Cloudflare GLM quota hit → brief missing | Med | Med | DeepSeek Flash fallback brief already exists; app shows whichever was generated | Pi |
| R006 | Image CDN URL goes dead (Yahoo CNBC etc.) | Med | Low | cached_network_image shows placeholder on failure; no crash | App |
| R007 | Pi offline (power, WiFi) → no new data | Med | Low | App shows cached data + "Last updated X hours ago" + health badge red | App |
| R008 | Flutter SDK version mismatch (Pi vs Windows) | Low | Med | Builds happen on Windows only; Pi doesn't run Flutter | Build |
| R009 | `hermes-data` repo grows too large (years of JSON) | Low | Low | Shallow clone on Pi git push; GitHub repo can hold decades of <100KB files | Pi |
| R010 | Android Google Play policy issue with raw.githubusercontent.com | Low | Med | Migrate to Cloudflare R2 with custom domain if needed | Architect |
