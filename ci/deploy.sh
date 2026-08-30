#!/usr/bin/env bash
# twobots local CI/CD deploy — builds MULTI-ARCH (amd64 + arm64 for Hurska), pushes the
# local registry (:latest + :sha- for rollback), redeploys Hurska, smoke-tests.
#
# No render step: the page is hand-authored static HTML. The image COPY list is an
# allowlist (see Dockerfile) so the provenance files are never served.
#
# Runs on Ruxa via `git push ruxa main` (post-receive) or by hand from the checkout.
set -euo pipefail
source "${CI_LIB:-/data/git/ci-lib.sh}"

HURSKA="ubuntu@192.168.4.33"
HURSKA_DIR="/data/twobots"
IMG="$REGISTRY/twobots"
PORT=8098

ci_trap "→ Hurska (twobots.dev)"
ci_lock
ci_ensure_buildx

# PRE-DEPLOY GATE. /assets/ is served max-age=2592000 while the page is no-cache, so a
# stylesheet edit reaches nobody unless its URL changes too — and there is no CF API
# token here to purge with. Assert the ?v= token still matches the file's bytes.
ci_log "assert cached assets carry a current cache-buster"
ci_assert_cache_busted index.html

# ---------------------------------------------------------------- pre-deploy gates
# These run on RUXA against the built index.html, not via `ssh $HURSKA curl` like the
# smoke tests below. A Packagist lookup has nothing to do with what nginx serves, and a
# broken install line should fail BEFORE a multi-arch image is built and pushed.

# The pip (orange, 3.33:1) is ornament and must never be a text colour. Adding <code>
# spans is exactly where that breaks.
ci_log "assert the ornament colour is never used as text"
if grep -q 'color: var(--pip)' index.html; then
  ci_die "index.html uses the pip as a text colour — it is 3.33:1, ornament only"
fi
ci_log "pip is ornament-only (correct)"

# Every advertised composer command must actually work. Checks `require` AND
# `create-project` with the same rule, so there is no special case to forget: publish the
# package and the line passes; do not, and the deploy fails.
#
# 200 is NOT sufficient. Composer's default minimum-stability is `stable`, so a package
# with only dev-* versions resolves on Packagist and still fails to install. Assert at
# least one non-dev version.
#
# A definitive 404 is FATAL; a transport failure is a WARNING. This is the estate's first
# gate that can fail on a third party's availability, and a Packagist outage must not turn
# an unrelated commit red in #duskana.
ci_log "assert every advertised composer package resolves with a stable version"
# `|| true`: grep exits 1 when it matches nothing, and under `set -euo pipefail` that
# aborts the script on the very case this branch exists to handle — no packages
# advertised. The empty-string branch below is unreachable without it.
PKGS=$(grep -oE 'composer (require|create-project) bjornbasar/[a-z0-9-]+' index.html \
       | awk '{print $NF}' | sort -u || true)
if [ -z "$PKGS" ]; then
  ci_log "no composer commands advertised — nothing to check"
else
  for PKG in $PKGS; do
    BODY=$(curl -sS --max-time 20 -w '\n%{http_code}' "https://repo.packagist.org/p2/$PKG.json" 2>/dev/null) || {
      ci_log "⚠ could not reach Packagist for $PKG — SKIPPING (transport failure, not a stale line)"
      continue
    }
    CODE=$(printf '%s' "$BODY" | tail -1)
    case "$CODE" in
      200) ;;
      404) ci_die "advertised package $PKG does NOT exist on Packagist — the install line on the page is broken" ;;
      *)   ci_log "⚠ Packagist returned $CODE for $PKG — SKIPPING (not a definitive 404)"; continue ;;
    esac
    STABLE=$(printf '%s' "$BODY" | sed '$d' | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)['packages']
    vs = [v['version'] for pkg in d.values() for v in pkg if not v['version'].startswith('dev-')]
    print(len(vs))
except Exception:
    print('ERR')
")
    [ "$STABLE" = "ERR" ] && { ci_log "⚠ could not parse Packagist JSON for $PKG — SKIPPING"; continue; }
    [ "$STABLE" = "0" ] && ci_die "$PKG has only dev-* versions — \`composer require\` fails under the default minimum-stability"
    ci_log "resolves (correct): $PKG — $STABLE stable version(s)"
  done
fi

# A signup CTA solicits an email and a password. Under the Privacy Act 2020 you have to
# say what you collect and why AT THE POINT OF COLLECTION, so a "sign up" link is only
# honest once that app has a privacy policy. All four hosted apps accept registration
# today and none has one — this gate is what stops the CTA landing before the policy does.
#
# Deliberately keyed on the LINKED HOST, not on the word "sign up" anywhere on the page:
# the page talks *about* sign-ups in the explanatory aside, and a naive word-grep would
# fail on its own honesty note.
ci_log "assert no signup CTA points at an app without a privacy policy"
# Same no-match trap as above, and here the no-match case is the DESIRED state.
# Matches BOTH zones. The apps migrated to *.twobots.dev (cards/budget/cookbook/hub) and
# the old *.minified.work names now 301 across — so a minified-only pattern had gone blind:
# a CTA to budget.twobots.dev/register would have sailed straight through the gate.
CTA_HOSTS=$(grep -oE 'href="https://[a-z-]+\.(minified\.work|twobots\.dev)/(register|signup|sign-up)[^"]*"' index.html \
            | sed -E 's|href="https://([^/]+)/.*|\1|' | sort -u || true)
if [ -z "$CTA_HOSTS" ]; then
  ci_log "no signup CTAs on the page (correct — the apps have no privacy policy yet)"
else
  for H in $CTA_HOSTS; do
    CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "https://$H/privacy" 2>/dev/null) || {
      ci_log "⚠ could not reach https://$H/privacy — SKIPPING (transport failure)"; continue; }
    [ "$CODE" = "200" ] || ci_die "the page invites signup at $H but https://$H/privacy returns $CODE — write the policy before the CTA"
    ci_log "signup CTA is backed by a policy (correct): $H"
  done
fi

# A repo flipped private 404s silently, leaving dead links on a page whose whole job is
# sending people to code.
ci_log "assert every linked GitHub repo is reachable"
for URL in $(grep -oE 'https://github\.com/bjornbasar/[a-zA-Z0-9._-]+' index.html | sort -u); do
  CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "$URL" 2>/dev/null) || {
    ci_log "⚠ could not reach $URL — SKIPPING (transport failure)"; continue; }
  [ "$CODE" = "200" ] || ci_die "$URL returned $CODE — a linked repo is private or gone"
  ci_log "reachable (correct): $URL"
done

# The karhu documentation link. Its canonical home is framework.twobots.dev (declared in
# karhu/mkdocs.yml) but that host is still being built, so the page currently points at the
# GitHub Pages copy — the one that resolves. This gate is what makes the eventual swap safe:
# point it anywhere, and the deploy proves the target answers before it ships. Same shape as
# the Packagist gate — a definitive 4xx/5xx is fatal, a transport failure only warns.
ci_log "assert the documentation link resolves"
for URL in $(grep -oE 'href="https://(framework\.twobots\.dev|bjornbasar\.github\.io)/[^"]*"' index.html \
             | sed -E 's/^href="//; s/"$//' | sort -u || true); do
  CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "$URL" 2>/dev/null) || {
    ci_log "⚠ could not reach $URL — SKIPPING (transport failure)"; continue; }
  [ "$CODE" = "200" ] || ci_die "the documentation link $URL returns $CODE — do not advertise docs that are not up yet"
  ci_log "docs link resolves (correct): $URL"
done

# A published address that bounces is the same class of failure as a dead store badge or a
# broken install line: it looks like a way to reach someone and is not. This page carried
# bjorn@minified.work for weeks precisely because twobots.dev had no MX yet.
#
# Checks the zone has MX, not that a mailbox exists — Google accepts every recipient at
# RCPT and validates later, so a mailbox probe cannot tell a real address from a fake one.
# MX is the part that is actually verifiable from here.
ci_log "assert every published email domain can receive mail"
for DOM in $(grep -oE 'mailto:[^"@]+@[a-zA-Z0-9.-]+' index.html | sed 's/.*@//' | sort -u || true); do
  MX=$(dig +short MX "$DOM" 2>/dev/null | grep -c . || true)
  [ "$MX" != "0" ] || ci_die "mailto: on the page uses @$DOM, which has NO MX records — mail to it bounces"
  ci_log "can receive mail (correct): @$DOM — $MX MX record(s)"
done

# The legal pages are served by AYULA, not by this container — one file mounted at /terms/
# and /privacy/ on twobots.dev and on every app subdomain, so each app's policy link is
# same-origin. They are therefore invisible to the smoke tests below, which only see what
# nginx-in-the-image serves. Check them where they actually live.
#
# The footer links them, so a broken mount would leave two dead links on the page, and the
# apps would lose the policy they are legally required to show at the point of collection.
ci_log "assert the shared Terms and Privacy Policy answer on every host that links them"
for H in twobots.dev cards.twobots.dev budget.twobots.dev cookbook.twobots.dev hub.twobots.dev tongits.twobots.dev pusoy.twobots.dev; do
  for DOC in terms privacy; do
    CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "https://$H/$DOC/" 2>/dev/null) || {
      ci_log "⚠ could not reach https://$H/$DOC/ — SKIPPING (transport failure)"; continue; }
    [ "$CODE" = "200" ] || ci_die "https://$H/$DOC/ returns $CODE — the Ayula mount is broken"
  done
  ci_log "legal pages served (correct): $H"
done

# Same shape, one document instead of two: each app's own privacy annex, additional to the
# base policy above and specific to that app (twobots.dev itself has no annex — it is not an
# app with its own accounts or data). Also served by Ayula, not this container — see above.
ci_log "assert each app's own privacy annex answers on its own host"
for H in cards.twobots.dev budget.twobots.dev cookbook.twobots.dev hub.twobots.dev tongits.twobots.dev pusoy.twobots.dev; do
  CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "https://$H/privacy-annex/" 2>/dev/null) || {
    ci_log "⚠ could not reach https://$H/privacy-annex/ — SKIPPING (transport failure)"; continue; }
  [ "$CODE" = "200" ] || ci_die "https://$H/privacy-annex/ returns $CODE — the Ayula mount is broken"
  ci_log "privacy annex served (correct): $H"
done

# POSITIVE assertions. Every other check here is a negative grep; the page had none of
# these, and doubling the copy is exactly when something load-bearing gets dropped in an
# edit. minified.work has 157 assertions — this is the minimum equivalent.
ci_log "assert the load-bearing content is still present"
for NEEDLE in \
  'not on any app store yet' \
  'https://tongits.twobots.dev/' \
  'four apps you can self-host' \
  'www.minified.work' \
  'bjorn.basar.co.nz' \
  'composer require bjornbasar/karhu' \
  'GitHub Issues'
do
  grep -qF "$NEEDLE" index.html || ci_die "missing from the page: '$NEEDLE'"
  ci_log "present (correct): '$NEEDLE'"
done

ci_log "build + push multi-arch: $IMG (:latest + :sha-$CI_SHA)"
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 \
  -t "$IMG:latest" -t "$IMG:sha-$CI_SHA" --push .

ci_log "sync compose + redeploy on Hurska"
rsync -a docker-compose.yml "$HURSKA:$HURSKA_DIR/"
ssh "$HURSKA" "cd $HURSKA_DIR && docker compose pull && docker compose up -d --remove-orphans && docker image prune -f"

# Smoke-test the page AND that the provenance files are absent — a regression in the
# Dockerfile's allowlist would otherwise publish them silently.
ci_log "smoke-test the deployed container"
ssh "$HURSKA" "curl -sf -o /dev/null -w 'twobots / → HTTP %{http_code}\n' http://localhost:$PORT/"
for LEAK in /content.md /README.md /Dockerfile; do
  CODE=$(ssh "$HURSKA" "curl -s -o /dev/null -w '%{http_code}' http://localhost:$PORT$LEAK")
  [ "$CODE" = "404" ] || ci_die "provenance file $LEAK is being SERVED (HTTP $CODE) — check the Dockerfile COPY allowlist"
  ci_log "not served (correct): $LEAK → 404"
done

# The self-hosted fonts must actually resolve. diana-cv shipped with a LINKED fonts.css
# whose url()s were document-relative, so every face 404'd and the page silently fell
# back to system fonts — invisible unless you look for it.
ci_log "assert the self-hosted fonts resolve"
CODE=$(ssh "$HURSKA" "curl -s -o /dev/null -w '%{http_code}' http://localhost:$PORT/assets/fonts/oswald-400-latin.woff2")
[ "$CODE" = "200" ] || ci_die "oswald-400-latin.woff2 → HTTP $CODE — the fonts are NOT loading, check fonts.css url() paths"
ci_log "fonts resolve (correct): oswald-400-latin.woff2 → 200"

# THE HONESTY GATE, specific to this page. Nothing is published to any store yet, so a
# store badge or link would point nowhere — it reads as broken or dishonest, and it is
# exactly the sort of thing that gets pasted in "ready for launch" and forgotten. When
# there IS a listing, delete this block in the same commit that adds the link.
ci_log "assert no store badge or store link is served (nothing is published yet)"
if ssh "$HURSKA" "curl -s http://localhost:$PORT/ | grep -qiE 'play\\.google\\.com|apps\\.apple\\.com|app-?store|google-?play|GetItOnGooglePlay'"; then
  ci_die "a STORE LINK OR BADGE is being served — there is no listing behind it yet (see content.md)"
fi
ci_log "no store badge or link served (correct)"

# No phone numbers on any static site (policy, 2026-08-07).
ci_log "assert no phone number is served"
if ssh "$HURSKA" "curl -s http://localhost:$PORT/ | grep -qE '\\+?64[ -]?[0-9][0-9 ()-]{7,}|\\b0[27][0-9]{7,9}\\b'"; then
  ci_die "a PHONE NUMBER is being served — phone numbers are stripped from all statics"
fi
ci_log "no phone number served (correct)"

# Best-effort ghcr copy. PUBLIC: unlike diana-cv/mrs-peopsquik this repo holds no
# third-party personal data, and a store publisher's site is reasonable to have open.
ci_log "ghcr copy (best-effort)"
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 \
  -t "$GHCR_NS/twobots:latest" --push . \
  || ci_log "⚠ ghcr copy failed (non-fatal; deploy already done)"
