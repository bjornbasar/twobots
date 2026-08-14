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
