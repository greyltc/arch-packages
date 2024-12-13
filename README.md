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
docker buildx build --progress plain --target build --tag built --load .
docker buildx build --progress plain --target export --output type=local,dest=out .
```
build artifacts will have now appeared in `out/`
