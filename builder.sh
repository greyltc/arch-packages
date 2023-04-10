#!/usr/bin/env bash
set -e
set -o pipefail

main() {
	pacman-key --init
	pacman --sync --refresh

	useradd --create-home archie
	echo "archie ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_archie_to_pacman"
	echo "root ALL=(ALL) CWD=* ALL" > /etc/sudoers.d/permissive_root_Chdir_Spec

	curl --silent --location https://gist.githubusercontent.com/greyltc/8a93d417a052e00372984ff8ec224703/raw/7b438370dbb63683849c7ed993f54a47ffe4d7dd/makepkg-url.sh > /usr/bin/makepkg-url
        chmod +x /usr/bin/makepkg-url

	mkdir --parents /out

	chown --recursive archie /packages /out

	install_paru

	cd /packages
	for d in */ ; do
		pushd "${d}"
		if test ! -f DONTBUILD -a -f PKGBUILD; then
			this_ver=$(getver)
			runuser -u archie -- makepkg --allsource
			mv *.src.tar.gz /out/.
			runuser -u archie -- paru --upgrade --noconfirm
			clean_orphans
			mv *.pkg.tar.zst /out/.
			sudo --user=archie --chdir=~ rm --recursive --force ~/.cargo
		else
			echo "Skipping ${d}"
		fi
		popd
	done
}

install_paru() {
	pushd /home/archie
	runuser -u archie -- curl --silent --location --remote-name https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=paru-bin
	this_ver=$(getver)
	runuser -u archie -- makepkg-url "file:///home/archie/PKGBUILD" --syncdeps --install --clean --noconfirm --rmdeps
	rm PKGBUILD
	rm --recursive --force .cargo
	popd
	clean_orphans
}

getver() {
        SRCINFO="$(runuser -u archie -- makepkg --printsrcinfo)"
        pkgver=$(awk '$1 == "pkgver" { print $3}' <<< "${SRCINFO}")
        pkgrel=$(awk '$1 == "pkgrel" { print $3}' <<< "${SRCINFO}")
        epoch=$(awk '$1 == "epoch" { print $3}' <<< "${SRCINFO}")
        if test -z "${epoch}"; then
                printf ${pkgver}-${pkgrel}
        else
                printf ${epoch}:${pkgver}-${pkgrel}
        fi
}

clean_orphans() {
	ORPHANS="$(pacman --query --unrequired --deps --quiet || true)"
	if test ! -z "${ORPHANS}"; then
		sudo pacman --remove --nosave --recursive --noconfirm ${ORPHANS}
	fi
}

main
