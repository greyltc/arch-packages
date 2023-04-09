# arch-packages
Packages for Arch Linux
## Building locally
```
git clone https://github.com/greyltc/arch-packages.git
cd arch-packages
docker buildx build --progress plain --target build --tag built --load .
docker buildx build --progress plain --target export --output type=local,dest=out .
```
results are in out/
