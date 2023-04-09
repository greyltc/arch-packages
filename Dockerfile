# syntax=docker.io/docker/dockerfile:1.5.2
FROM archlinux:base-devel as build
COPY . /packages/.
RUN <<EOF
#!/usr/bin/env bash
set -e
set -o pipefail

pacman-key --init
pacman -Sy

useradd -m archie
echo "archie ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_archie_to_pacman"

curl -sLO https://gist.githubusercontent.com/greyltc/8a93d417a052e00372984ff8ec224703/raw/7b438370dbb63683849c7ed993f54a47ffe4d7dd/makepkg-url.sh
sudo -u archie bash makepkg-url.sh "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=paru" -sic --noconfirm

mkdir -p /out

chown -R archie /packages /out

cd /packages
for d in */ ; do
  pushd "${d}"
  sudo -u archie paru -U --noconfirm
  mv *.pkg.zst /out/.
  popd
done

EOF

FROM scratch AS export
COPY --from=build /out/* /
