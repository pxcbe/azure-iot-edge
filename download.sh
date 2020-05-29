#!/bin/bash
set -x
mkdir tmp_moby

curl -L https://aka.ms/moby-engine-armhf-latest -o moby_engine.deb
dpkg -x ./moby_engine.deb tmp_moby

curl -L https://aka.ms/moby-cli-armhf-latest -o moby_cli.deb
dpkg -x ./moby_cli.deb tmp_moby

cp -R ./tmp_moby/* ./archive/
