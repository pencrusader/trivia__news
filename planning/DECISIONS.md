# Decision Log — Hermes News Reader

## Format
Each decision: date, what was decided, context, alternatives considered, consequences.

---

## 2026-06-29: GitHub as data store (not Flask on Pi)

**Context:** Original plan had Pi running a Flask server, phone connecting over local WiFi. This meant the app only worked at home and the Pi had to manage a server process.

**Alternatives considered:**
- Flask on Pi → phone over WiFi (rejected: local-only, server management)
- Cloudflare R2 → global, free, but second account needed
- Supabase → proper DB, but adds dependency and free tier has limits
- Telegram Bot API → already working, but we're replacing Telegram

**Decision:** GitHub public repo `pencrusader/trivia__news`. Pi pushes JSON via cron `git push`. Phone fetches from `raw.githubusercontent.com`. Global CDN, free, zero new infrastructure.

**Consequences:**
- No Pi server process to manage
- Works anywhere phone has internet
- Public data only (acceptable — all news is public)
- GitHub CDN has good global latency
- Migration to R2 is a one-line URL change if needed

---

## 2026-06-29: Client-side search (not API-based)

**Context:** Need to search across all briefs and articles. Server-side search would require a database.

**Alternatives considered:**
- Supabase full-text search (rejected: adds dependency, overkill)
- Elasticsearch on Pi (rejected: resource-heavy, ARM64 pain)
- Client-side over cached JSON (chosen)

**Decision:** App caches 7 days of JSON bundles locally (SQLite). Full-text search runs on the phone. <1000 articles = instant on any smartphone CPU.

**Consequences:**
- Search limited to cached date range (7 days, configurable)
- No server infrastructure needed
- Works offline

---

## 2026-06-29: Jina Reader direct from phone (not proxied through Pi)

**Context:** When user taps "Read Full Article", we need clean markdown from the original URL.

**Decision:** Phone calls `https://r.jina.ai/{url}` directly. Pi doesn't proxy.

**Consequences:**
- 200 req/hr Jina free tier is sufficient for single user
- Pi has zero load from article reading
- Slightly slower (phone → Jina → back) but acceptable for on-demand reading

---

## 2026-06-29: DeepSeek Flash for builds, Pro for architecture

**Context:** Flutter code generation is boilerplate-heavy. DeepSeek Flash is 3× cheaper than Pro.

**Decision:** Architecture, data contracts, and review by Pro. All code generation by Flash (delegated via news_reporter or direct builder).

**Consequences:**
- ~74% cost reduction vs all-Pro build
- Pro review catches architectural drift
- Flash medium/high reasoning sufficient for Dart/Flutter boilerplate

---

## 2026-06-29: Riverpod over Provider

**Context:** Flutter state management choice.

**Decision:** Riverpod. Type-safe, no BuildContext dependency in providers, better testability, compile-time safety. Provider was considered but Riverpod is the modern successor by the same author.

**Consequences:**
- Additional package dependency
- Slightly steeper learning curve (mitigated: Flash generates code)
