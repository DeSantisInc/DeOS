#!/bin/sh

rm -rf .deos/
mkdir .deos
mkdir .deos/bin
mkdir .deos/bin/darwin
mkdir .deos/bin/linux
mkdir .deos/ext
mkdir .deos/ext/darwin
mkdir .deos/ext/linux
mkdir .deos/obj
mkdir .deos/obj/darwin
mkdir .deos/obj/linux
mkdir .deos/venv
mkdir .deos/venv/darwin
mkdir .deos/venv/linux

rm -rf build/
mkdir build

cp src/build/delta.sh .deos/bin/darwin/delta
chmod +x .deos/bin/darwin/delta

cp src/build/deos.py .deos/bin/darwin/deos
chmod +x .deos/bin/darwin/deos

cp src/build/printm.py .deos/bin/darwin/printm
chmod +x .deos/bin/darwin/printm

.deos/bin/darwin/deos
make all
