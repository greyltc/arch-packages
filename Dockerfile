# syntax=docker.io/docker/dockerfile:1.5.2
FROM archlinux:base-devel as build
COPY . /packages/.
RUN <<EOF
#!/usr/bin/env bash
set -e
set -o pipefail

pacman-key --init
pacman --sync --refresh

useradd --create-home archie
echo "archie ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_archie_to_pacman"

curl --silent --location --remote-name https://gist.githubusercontent.com/greyltc/8a93d417a052e00372984ff8ec224703/raw/7b438370dbb63683849c7ed993f54a47ffe4d7dd/makepkg-url.sh
sudo --user=archie bash makepkg-url.sh "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=paru" --syncdeps --install --clean --noconfirm

mkdir --parents /out

chown --recursive archie /packages /out

cd /packages
for d in */ ; do
  pushd "${d}"
  sudo --user=archie makepkg --allsource
  mv *.src.tar.gz /out/.
  sudo --user=archie paru --upgrade --noconfirm
  mv *.pkg.tar.zst /out/.
  popd
done

EOF

FROM scratch AS export
COPY --from=build /out/* /
