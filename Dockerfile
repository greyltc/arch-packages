# syntax=docker.io/docker/dockerfile:1.5.2
FROM archlinux:base-devel as build
COPY . /packages/
COPY builder.sh /root/
RUN bash /root/builder.sh

FROM scratch AS export
COPY --from=build /out/* /
