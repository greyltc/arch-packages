# syntax=docker.io/docker/dockerfile:1.5.2
FROM archlinux:base-devel as build
COPY * /packages/.
RUN --network=none <<EOF
#!/usr/bin/env bash
set -e
set -o pipefail

mkdir -p /out
pushd /packages

ls -al > /out/test.txt

EOF

FROM scratch AS export
COPY --from=compile /out/* /
