# The TwoBots Apps landing page at https://twobots.dev/ — static nginx.
#
# Built multi-arch on Ruxa (amd64 + arm64), pushed to 192.168.4.9:5000, pulled on
# Hurska (Pi, arm64). Fronted by Ayula.
#
# COPY is an explicit ALLOWLIST. The repo also holds content.md and README.md, which
# record what is deliberately NOT on the page (no store badges, no screenshots, no
# launch date) — provenance, not content to serve. An allowlist fails closed: adding a
# file here cannot accidentally publish it. ci/deploy.sh asserts they 404 after deploy.
FROM nginx:alpine

LABEL org.opencontainers.image.source=https://github.com/bjornbasar/twobots
LABEL org.opencontainers.image.description="TwoBots Apps — landing page (twobots.dev)"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY assets/ /usr/share/nginx/html/assets/

EXPOSE 80
