# Sprint 001 — Discovery & Architecture — Requirements

## Goal
Define the complete architecture, data contract, and build plan for the Hermes News Reader Flutter app so that a Flash builder can independently implement Phase 1 (MVP).

## User Stories
- [x] As a reader, I want to see today's morning brief in a structured format with sections, headlines, and images so I can scan quickly without infinite scrolling
- [x] As a reader, I want to browse articles by section (Global Macro, Business, Tech, etc.) with rich image cards
- [x] As a reader, I want to swipe between dates to read yesterday's brief or last week's
- [x] As a reader, I want the app to work anywhere with internet, not just on home WiFi
- [ ] As a reader, I want to read full articles with clean formatting when I tap on one
- [ ] As a reader, I want to search across all briefs and articles
- [ ] As a reader, I want the app to show cached data when I'm offline

## Functional Requirements
- [ ] FR001: App fetches today's bundle from GitHub raw on launch
- [ ] FR002: Home screen shows brief sections with expandable article cards
- [ ] FR003: Article cards show image (with placeholder), title, source, time
- [ ] FR004: Date picker bar lets user switch between dates with cached data
- [ ] FR005: Pull-to-refresh reloads latest data from GitHub
- [ ] FR006: App caches last 7 days of bundles locally (SQLite)
- [ ] FR007: Offline mode: show cached data with "Updated X min ago" badge
- [ ] FR008: Pi health badge (green/yellow/red) based on cron status in JSON

## Non-Functional Requirements
- [ ] NFR001: Performance — Home screen renders in <1s on cold start
- [ ] NFR002: Payload — JSON bundle must be <100KB
- [ ] NFR003: Images — Lazy-loaded with placeholder, no layout shift
- [ ] NFR004: Offline — App never shows white screen; always shows cache or friendly empty state

## Edge Cases
- GitHub CDN timeout → show cached data + toast
- JSON parse failure → show cached data, log error
- No brief generated today (before 8 AM) → show "Brief coming soon" with last available
- Image URL null or broken → show placeholder image
- Zero articles in a section → hide section or show "No articles today"

## Out of Scope
- Push notifications
- Dark mode (Phase 3)
- iOS build (Phase 3)
- Full article reader via Jina (Phase 2)
- Search (Phase 2)
- Multi-user cloud backend
- TTS audio playback
