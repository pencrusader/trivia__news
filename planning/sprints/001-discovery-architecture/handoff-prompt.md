# Sprint 001 — Builder Handoff Prompt

> Copy-paste this entire prompt into your Builder tool, or use as a directive for a delegated Flash agent.

## Context
This is project `hermes-news-reader`. You are the Builder. You're writing a Flutter app that displays structured news data as a rich mobile reader.

**Important:** This app reads data from GitHub raw files. It does NOT connect to the Pi directly. The Pi pushes JSON to GitHub; the phone reads from the CDN.

## Before you start
1. Read `AGENTS.md` for project conventions
2. Read `docs/ARCHITECTURE.md` for design decisions (GitHub store, client-side search, Jina direct)
3. Read `docs/DATA_MODEL.md` for the EXACT JSON schema — your models must match this
4. Read `docs/API.md` for endpoint URLs

## What to build
See `sprints/001-discovery-architecture/blueprint.md` for component breakdown.

**Phase 1 MVP scope:**
1. Flutter project setup (pubspec.yaml, directory structure)
2. Data models: `Brief`, `Section`, `Article`, `HealthStatus` with `fromJson`
3. API service: fetch from GitHub raw
4. Cache service: SQLite with 7-day retention
5. Home screen: sections, article cards, date picker, pull-to-refresh
6. Health badge in AppBar
7. All loading/empty/error states

**Out of scope for this sprint:**
- Full article reader (Jina Reader) — stub the tap handler
- Search screen
- Settings screen
- Feed browser
- Dark mode
- Push notifications

## What "done" means
See `sprints/001-discovery-architecture/acceptance.md`

## Test data
Use the JSON in `acceptance.md` for development. Mock the HTTP client to return it.

## Rules
- Write models before screens
- Every screen must handle: loading, data, empty, error
- Use Riverpod providers for all async data
- `cached_network_image` with `CircularProgressIndicator` placeholder
- Article cards in a `GridView` (2 columns on tablet/landscape, 1 on phone portrait)
- Date picker: horizontal scrollable `ListView` of chips
- Health badge: `Container` with color + `PopupMenuButton` for details

## Deliverable
A complete `hermes-news-reader/` Flutter project that:
- Passes `flutter analyze` with zero errors
- Has unit tests for models + API service
- Builds APK with `flutter build apk --debug`
