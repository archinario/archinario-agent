#!/bin/sh
set -eu
out=${1:-dist/platform-check}
mkdir -p "$out"
for os in darwin linux windows; do
  for arch in amd64 arm64; do
    suffix=''; [ "$os" != windows ] || suffix='.exe'
    CGO_ENABLED=0 GOOS="$os" GOARCH="$arch" go build -trimpath -o "$out/archinario_${os}_${arch}$suffix" ./cmd/archinario
    printf 'Built %s/%s\n' "$os" "$arch"
  done
done
