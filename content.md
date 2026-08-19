# TwoBots Apps

Structured source for the page at [twobots.dev](https://twobots.dev/).
`index.html` is the thing being served; this file is the copy in a form that is easy to
read and reuse, plus the record of what is deliberately absent. Keep the two in step.

**The site is the products half of a two-site split:** `twobots.dev` is *what you can get*,
`www.minified.work` is *what can be built for you*. Each links to the other.

---

## Who

**TwoBots Apps** — software small enough to understand, made in Aotearoa New Zealand.
One person: [Bjorn Basar](https://bjorn.basar.co.nz/). The services side of the same
one-person studio is [minified.work](https://www.minified.work/).

> **On the eyebrow.** It reads "One person · Aotearoa New Zealand", *not* "not a studio",
> which is what it used to say. That negation sat one click from minified.work's
> "Software studio" and read as a contradiction — the facts agree (it IS a one-person
> studio, and minified.work says so), but the labels fought each other. State the scale;
> let the cross-link sentence reconcile the rest.

## The shelf, stated up front

> Four MIT-licensed PHP packages you can install today, and one card game you can play in
> your browser this minute — though not on any app store yet.

The count still goes at the top. It used to be there because the headline product was
unreleased and a page that makes you scroll to discover that reads as bait-and-switch; now it
is there because "you can play it right now" is the strongest thing the shelf has to say.

## For everyone — `#games`

**Tongits TwoBots** — three-player [Tongits](https://en.wikipedia.org/wiki/Tong-its), you
against two bots. Offline, no accounts, no ads.

**Status: publicly playable at [tongits.twobots.dev](https://tongits.twobots.dev/), not on any app store yet.**

| | |
|---|---|
| done | The engine: full hands, all three endings reachable, chips zero-sum across 10,000 simulated hands, no seat advantage |
| done | Playable in a browser against two bots, installable as an offline app |
| next | A real playtest — five players, one URL. The quality gate everything after depends on |
| then | Android as a thin shell around the web build; iOS only if it earns it |

Sourced from `karu/README.md` (M1 + M2 complete). **This drifted once already** — the page
claimed a browser build was "next" for four days after it shipped. If you change the
milestones there, change them here.

**Describe capability, not polish.** `karu`'s milestone table still lists "the real table"
(M5) as not done even though card faces and a board layout have landed. Saying "playable
and installable" is true under either reading; saying "beautiful" or "ugly text cards"
is not.

## For developers — `#dev`

| | install | state |
|---|---|---|
| **karhu** | `composer require bjornbasar/karhu` | v0.1.4 · MIT · PHP 8.3+ · PHPStan L8 |
| karhu-db | `composer require bjornbasar/karhu-db` | v0.1.0 · MIT |
| karhu-queue | `composer require bjornbasar/karhu-queue` | v0.3.0 · MIT |
| karhu-view | `composer require bjornbasar/karhu-view` | v0.1.0 · MIT |
| istrbuddy | *(not on Packagist — clone it)* | reference app, MIT |

**Said plainly on the page:** everything is 0.x, and `karhu-db` / `karhu-view` last
released April 2026. Stable in the sense that they run in production daily — not in the
sense of a 1.0 or a release cadence. A developer evaluating "can I use this at work"
checks licence, 1.0 and last release; two of those are weak, so the page says so rather
than letting them find out.

**`istrbuddy` is labelled a reference app, not a product.** Its `composer.json` pins
`karhu-db: dev-main` with `minimum-stability: dev`; a committed lockfile makes clone-and-run
reproducible, but "an issue tracker you can run" would invite feature requests it is not
there to serve.

**`karhu-skeleton` is deliberately absent.** It is not on Packagist, so
`composer create-project` would 404 — and `karhu`'s own README opens with exactly that
command. Publishing it is a prerequisite for advertising it here, and the deploy gate
enforces that automatically: the moment it resolves, the line can go in.

**Documentation:** linked first on the karhu card, ahead of GitHub and Packagist — it is
what a developer wants before either.

It currently points at **`bjornbasar.github.io/karhu`** because that is the URL that
*resolves*. The canonical home is **`framework.twobots.dev`** — `karhu/mkdocs.yml` already
declares it as `site_url`, which is also what makes the Pages copy a non-competing DR
mirror — but that host is still being built and 404s today. Advertising it early would be
the dead-link failure the deploy gates exist to prevent.

**Swapping it is one edit per site** (`twobots/index.html`, `minified/content.mjs`,
`sloth/content.mjs`), and the twobots deploy **asserts the docs link returns 200**, so a
premature swap fails the deploy rather than shipping a 404 to three public sites.

**Support: GitHub Issues** on the relevant repo. Public on purpose.

## Contact

`dev@twobots.dev` — brand-matched, and confirmed receiving (a test message arrived
2026-08-19).

It was `bjorn@minified.work` until then, because the zone had no MX and anything
`@twobots.dev` bounced. Publishing an address that silently fails is worse than publishing
one that works but is off-brand.

**The swap touched three files, not the two this note used to claim** — `index.html`,
this file, and `README.md`. Worth recording: a note that undercounts its own footprint is
how the next person misses one. `ci/deploy.sh` now asserts that every `mailto:` domain on
the page has MX records, so a bouncing address cannot be published again.

---

## What is deliberately not here

- **No store badges or store links.** Nothing is published. A "Get it on Google Play"
  badge pointing nowhere reads as broken or dishonest. The deploy asserts their absence;
  delete that assertion in the same commit that adds a real listing.
- ~~**No "Play it" link.**~~ *(This rule is now spent.)* It existed because the game had no
  public URL. It has one — `tongits.twobots.dev`, on Hurska behind Ayula — so the card links
  to it. The store-badge rule below is a SEPARATE rule and still stands: a playable web build
  is not a store listing, and the page says so in both places.
- **No screenshots.** *(This rule changed.)* It used to be "there is no UI"; there is one
  now. It is held back because `karu`'s own milestones still list the real table as not
  done, so a shot could misrepresent the polish in either direction.
- **No ratings, download counts or launch date.** Nothing to count; a date would be a guess.
- **No "we".** It is one person, and the page says so.
- **No privacy policy.** Deliberate and tracked — see below.
- **`mishka` is not on the shelf** even though its repo is public and minified.work calls
  it the framework's flagship proof. It is a family-hub app for one household, not
  something to install. The page says so, because its absence would otherwise look like an
  oversight.

## Two things that must not quietly land here

**The app's privacy/support page belongs OFF-FLEET on Cloudflare Pages** (`karu/DOCS.md`).
Google requires a non-geofenced, non-editable, non-PDF URL plus an in-app link, and such a
URL 502-ing during review is a rejection — on a Pi behind a residential line. This page is
marketing, so an outage costs a visitor rather than a submission.

**The PWA's public URL is load-bearing, not marketing.** `karu/ANDROID.md` makes Android a
**TWA** — the app *is* the deployed website — with `assetlinks.json` required at that
origin's root, for package `dev.twobots.tongits`. So where the web build is hosted decides
whether `twobots.dev`'s apex can stay on Hurska. **Decide before M3, not after.**
