#!/bin/bash

set -e -x

release_dir="$(dirname $0)/.."

pushd $release_dir # RELASE_ROOT

collector_version=$(cat ./scripts/version)

file="collector-v${collector_version}.tar.xz"

deb="appfirst-latest-x86_64.deb"
url="http://wwws.appfirst.com/packages/updates/${deb}"

tmp=$(mktemp -d tmp_collector_XXXXXXXXXXXX) # TMP

pushd $tmp

mkdir -p afupstream appfirst afcollector/{bin,conf,lib,plugins}

curl -sOL ${url}
tar zxf ${deb} data.tar.gz
tar zxf data.tar.gz -C afupstream/

mv afupstream/usr/bin/collector                       afcollector/bin/afcollector
mv afupstream/usr/share/appfirst/afcollector.conf     afcollector/conf/
mv afupstream/usr/share/appfirst/*lib*                afcollector/lib/
mv afupstream/usr/share/appfirst/plugins2/{etc,share} afcollector/plugins/

tar -zvxf afupstream/usr/share/appfirst/plugins2/af_polled.tgz -C afcollector/plugins/
tar -cf collector.tar afcollector 
xz -9 collector.tar

mv collector.tar.xz ${file}

popd #TMP

bosh add blob ${tmp}/${file} appfirst

rm -rf ${tmp}

popd # RELASE_ROOT



