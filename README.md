# Hermes News Reader

Flutter mobile app that reads structured news data from the Hermes Pi pipeline. Replaces Telegram text delivery with rich article cards, images, and date navigation.

## Quick Start

```bash
cd hermes-news-reader
flutter pub get
flutter run
```

> Requires Flutter SDK 3.2+. The app fetches data from GitHub raw CDN — no Pi connection needed for development. Use the test JSON in `planning/sprints/001-discovery-architecture/acceptance.md`.

## Project Structure

This project follows the [Agent-Ready Project Structure](AGENTS.md) convention.

```
hermes-news-reader/
├── docs/          # Architecture, data model, API spec
├── planning/      # Decisions, sprint plans, risk register
├── lib/           # Flutter app code (to be built)
├── android/       # Android platform (flutter create)
├── ios/           # iOS platform (flutter create)
└── pubspec.yaml   # Flutter dependencies
```

## Architecture

Pi pushes JSON → GitHub → Phone fetches from CDN. No direct Pi↔Phone connection.

See `docs/ARCHITECTURE.md` for the full design.

## Status

See `planning/STATE.md`. Currently: Architecture complete, ready for build.

