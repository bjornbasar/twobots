# TwoBots Apps

Structured source for the landing page at [twobots.dev](https://twobots.dev/).
`index.html` is the thing being served; this file is the copy in a form that is easy to
read and reuse. Keep the two in step.

---

## Who

**TwoBots Apps** — small games, made in Aotearoa New Zealand. One person, not a studio:
built by [Bjorn Basar](https://bjorn.basar.co.nz/), whose other work is at
[minified.work](https://www.minified.work/).

## The first game

**Tongits TwoBots** — three-player [Tongits](https://en.wikipedia.org/wiki/Tong-its):
you against two bots. Offline, no accounts, no ads.

Tongits is a Filipino card game — three players, a 52-card deck, melds and discards, and
three ways a hand can end. The name is the pitch: the other two seats are bots, so a hand
takes as long as you want it to and never waits on anyone.

**Status: in development. Not released yet.**

| | |
|---|---|
| The engine | Done — full hands play out, all three endings reachable, chips zero-sum over 10,000 simulated hands, no seat advantage |
| A playable build | Next |
| Google Play | After that |
| iOS | Only if it earns it |

Sourced from `karu/README.md` — the repo is `karu` (Estonian *bear*, per the workspace
naming convention). Keep the numbers here in step with that file, or drop them rather
than let them drift.

## Contact

**Now:** `bjorn@minified.work`
**Intended:** `dev@twobots.dev` — swap it in once mail is configured.

**Why not `dev@twobots.dev` yet:** the zone has **no MX records**, so anything
`@twobots.dev` bounces today. Publishing an address that silently fails is worse than
publishing one that works but is off-brand. The three sibling zones (`minified.work`,
`basar.co.nz`, `peopsquik.com`) all carry Google Workspace MX, which is why one of those
stands in.

**To switch:** add Workspace MX (or a routing entry) to the `twobots.dev` zone, verify
delivery, then change the single `mailto:` in `index.html` and this file. There is no
other place the address appears.

---

## What is deliberately not here

Recorded so none of it reads as an oversight.

- **No store badges.** There is no listing to link to. A "Get it on Google Play" badge
  pointing nowhere is worse than no badge — it reads as either broken or dishonest.
  `ci/deploy.sh` asserts no `play.google.com` or `apps.apple.com` link is served, so one
  cannot be added ahead of a real listing.
- **No screenshots.** There is no UI yet (that is the next milestone). Mock-ups presented
  as a product are the same lie in a different medium.
- **No ratings, download counts, or launch date.** Nothing to count, and a date would be
  a guess.
- **No "we".** It is one person. The page says so.
- **No roadmap detail beyond the four lines above.** The full M0–M7 milestone table lives
  in the repo; publishing an internal schedule invites questions it cannot answer.
- **No privacy policy.** Deliberate, and tracked: the app will need one before the first
  Play upload, and `karu/DOCS.md` already rules that it goes **off-fleet on Cloudflare
  Pages** — Google requires a non-geofenced, non-editable, non-PDF URL plus an in-app
  link, and a store-mandated URL 502-ing during review is a rejection. This page is
  marketing only, so the homelab is a fine host for it; the policy is not, and must not
  quietly end up here.
