[![Build and Release Arch Linux packages](https://github.com/greyltc/arch-packages/actions/workflows/build.yaml/badge.svg)](https://github.com/greyltc/arch-packages/actions/workflows/build.yaml)
# arch-packages
Packages for Arch Linux
## Building locally
```
git clone https://github.com/greyltc/arch-packages.git
cd arch-packages
run0 pacman -Syu --needed docker docker-buildx
run0 usermod -a -G docker "${USER}"
newgrp docker
run0 systemctl start docker
git clone https://github.com/greyltc/build-arch-packages-action.git
mkdir -p out/cache && docker buildx build --progress plain --target build --tag built --load --build-context packages=. --build-context cache=out/cache build-arch-packages-action
mkdir -p out/cache && docker buildx build --progress plain --target export --output type=local,dest=out --build-context packages=. --build-context cache=out/cache build-arch-packages-action
```
build artifacts will have now appeared in `out/`
