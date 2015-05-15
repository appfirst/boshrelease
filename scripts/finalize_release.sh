#!/bin/bash

set -e -x

release_dir="$(dirname $0)/.."

pushd $release_dir # RELASE_ROOT

collector_version=$(cat ./scripts/version)

bosh -n upload blobs

git add -u
git add config/blobs.yml
git commit -m "Blobs for collector v$collector_version"

bosh -n create release --final --name appfirst --version ${collector_version}
git add -u
git add releases
git commit -m "Release for collector v$collector_version"

popd # RELASE_ROOT

