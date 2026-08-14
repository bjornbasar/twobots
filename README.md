# twobots — the TwoBots Apps landing page

**This IS the page at [twobots.dev](https://twobots.dev/)** — live since **14 August 2026**.

`twobots.dev` is the forward-facing publisher domain for **TwoBots Apps**: small games for Google Play and, eventually, the App Store. This repo is the landing page only — one screen saying who the publisher is, what the first game is, and honestly that it is not out yet.

The game itself lives in [`../karu`](../karu) (`karu` = Estonian *bear*, per the workspace naming convention). Store name **Tongits TwoBots**.

## Contents

| Path | What |
|------|------|
| `index.html` | The page. Hand-authored, no build step. |
| `content.md` | The **copy as structured source**, plus the record of what is deliberately omitted. Start here. |
| `assets/fonts/` | **Self-hosted** Oswald + Open Sans (woff2, latin + latin-ext). |
| `assets/fonts.css` | The `@font-face` block. See the warning below. |
| `assets/favicon.svg` | The TwoBots mark, from [`../logos/twobots.dev`](../logos/twobots.dev). |
| `Dockerfile`, `nginx.conf`, `docker-compose.yml`, `ci/deploy.sh` | Image + serving config + deploy. |

## The name breaks the bear convention on purpose

The workspace names public projects and domains after bears. `twobots.dev` does not — it is a **store publisher brand**, and "TwoBots" is the pitch for the first game (you plus two bots). The convention still holds where it matters: the game's repo is `karu`.

Same reasoning as `minified`, and recorded in [`../bear-names.md`](../bear-names.md) so it reads as a decision rather than a lapse.

## Palette — Izzet (U/R)

The fifth public domain. Per the by-role convention, personal domains are mono-colour and functional domains take a two-colour guild (`minified.work` Selesnya G/W, `peopsquik.com` Orzhov W/B). **Blue for the bots, red for play** — and Izzet is MTG's invention guild, which suits a hand-rolled card engine.

Measured against the shared cream ground `#FDF4EE`:

| | contrast | |
|---|---|---|
| **ink** — steel blue `#275E8C` | **6.31:1** | all text: links, headings, the eyebrow |
| **ornament** — orange `#D06B22` | 3.33:1 | section rules, the card edge, the status dot. **Never text** |

Same ink/ornament split `mrs.peopsquik.com` needed, for the same reason: at these hues the warm half cannot carry text. Every text/background pair clears AA in both modes; the lowest is muted-on-card-tint at **5.08:1**. Verified by computed style that `color: var(--pip)` appears **zero** times — the rule is enforced, not just documented.

### The R has to skew orange, not gold

The palette rule already assigns **gold/yellow as the stand-in for MTG white** — that is exactly how Orzhov works on `peopsquik.com` (gold tile `#BF9311`). A gold-leaning amber here (`#C8871F`, 2.79:1) sits almost on top of it and would quietly read as **W**, making this Azorius rather than Izzet. `#D06B22` reads unambiguously as R, and is far enough in hue from `basar.co.nz`'s terracotta `#C63F2A` to stay distinct.

## ⚠ `fonts.css` paths are stylesheet-relative, and there is a cache-buster

Two things inherited as scar tissue from `diana-cv`:

- `index.html` **links** `assets/fonts.css`, and CSS resolves `url()` against **the stylesheet's own location** — so the paths are `fonts/…`, not `assets/fonts/…`. The document-relative form resolves to `/assets/assets/fonts/…` and 404s, which `diana-cv` shipped for months while silently falling back to system fonts.
- The reference carries **`?v=<sha256[:8]>`**. `/assets/` is served `max-age=2592000` and there is no Cloudflare API token to purge with, so editing `fonts.css` reaches nobody unless the URL changes too. `ci_assert_cache_busted` in [`../ci/lib.sh`](../ci/lib.sh) fails the deploy on a stale token; `../ci/stamp-cache.sh index.html` fixes it.

## Hosting and deploy

`nginx:alpine` on **Hurska** (Pi, arm64) at `:8098`, reverse-proxied by **Ayula** as `https://twobots.dev` and `https://www.twobots.dev` (`twobots.dev` Cloudflare Origin cert). Ayula intercepts 404s and serves the branded twobots.dev page via `@e404_2bot`.

```bash
git push ruxa main     # → post-receive on Ruxa → ci/deploy.sh
```

Build → multi-arch image → local registry `192.168.4.9:5000` (`:latest` + `:sha-<short>`) → redeploy Hurska → smoke-test → best-effort ghcr copy. Rollback = repin the compose `image:` to a prior `:sha-`.

**The vhost was the whole cutover.** `twobots.dev`'s wildcard already resolved to Ayula (apex, `www` and any subdomain all returned **520** — CF's report of Ayula's `default` server firing `return 444`), and the CF Origin cert pair was already installed. No Cloudflare DNS change was needed.

### `.dev` is HSTS-preloaded

The whole `.dev` TLD is on the HSTS preload list, so browsers refuse plain HTTP outright. The `:80 → :443` redirect server exists for correctness and non-browser clients; no real visitor will reach it.

## The honesty gate is a deploy assertion, not a good intention

Nothing is published to any store yet, so `ci/deploy.sh` **fails the deploy** if the served page contains a `play.google.com` or `apps.apple.com` link, or store-badge markup. A "Get it on Google Play" badge pointing nowhere reads as broken or dishonest, and it is exactly the sort of thing that gets pasted in during launch prep and forgotten.

**When there is a real listing, delete that block in the same commit that adds the link.**

The deploy also asserts the provenance files 404, the fonts resolve, and no phone number is served (estate-wide rule).

## What is deliberately not here

Full detail in `content.md`. In short: no store badges, no screenshots of a UI that does not exist, no ratings or download counts, no launch date, no "we" (it is one person), and no privacy policy.

That last one is deliberate and tracked — see below.

## The privacy policy does NOT belong here

[`../karu/DOCS.md`](../karu/DOCS.md) already ruled it: the app's privacy/support page goes **off-fleet on Cloudflare Pages**, because Google requires a non-geofenced, non-editable, non-PDF URL *plus* an in-app link, and **a store-mandated URL 502-ing during review is a rejection** — on a Pi behind a residential line.

This landing page is marketing only, so the homelab is a fine host for it: an outage costs a visitor, not a review. **Before the first Play upload**, the policy must exist off-fleet. It must not quietly end up in this repo because this repo was convenient.

The estate's shared `/privacy/` page is also **not** mounted here. It opens "These are personal sites run by Bjorn Basar" and describes server logs and a beacon — this is a business-facing publisher domain, excluded for the same reason `www.minified.work` was, and the app needs a different document again.

## Analytics

Cookieless, self-hosted **GoatCounter** (`otso.minified.work`), recording `location.hostname` so this site is separable from its siblings on the shared instance. Disclosed in one footer line: no cookies, nothing shared.

## Contact

The page shows `bjorn@minified.work`. The intended address is **`dev@twobots.dev`**, blocked on one thing: the `twobots.dev` zone has **no MX records**, so mail to it bounces today. Add Workspace MX (or a routing entry) to the zone, verify delivery, then change the single `mailto:` in `index.html` and the note in `content.md` — those are the only two places it appears.
