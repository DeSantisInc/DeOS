#!/bin/sh

rm -rf build/

mkdir build

rm bin/deos

cp src/tools/deos.py bin/deos

chmod +x bin/deos

./bin/deos

make all
