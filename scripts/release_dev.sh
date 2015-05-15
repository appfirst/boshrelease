#!/bin/bash

set -e -x

release_dir="$(dirname $0)/.."

pushd $release_dir # RELASE_ROOT

bosh create release --force --with-tarbal --name appfirst
bosh -n upload release
bosh releases

popd # RELASE_ROOT
