#!/bin/sh

HOST_OS=$(uname)

EXIT_SUCCESS() {
  exit 0
}

EXIT_FAILURE() {
  exit 1
}

deos_bin() {
  for path in .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis
  do
    [ ! -f "$path/deos" ] && cp src/deos.py $path/deos
    [ ! -f "$path/logger" ] && cp src/logger.py $path/logger
    [ ! -f "$path/print" ] && cp src/print.py $path/print
    [ ! -f "$path/spinner" ] && cp src/spinner.sh $path/spinner
    chmod +x $path/deos # add: if-darwin
    chmod +x $path/logger # add: if-darwin
    chmod +x $path/print # add: if-darwin
    chmod +x $path/spinner # add: if-darwin
  done
}

deos_venv() {
  path=.deos/venv/$1
  bin=virtualenv
  venv=default
  flag=--no-site-packages
  [ ! -d "$path/$venv" ] && (cd $path && $bin $venv $flag)
}

deos_init() {
  for path in .deos .deos/bin .deos/obj .deos/venv\
              .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis\
              .deos/obj/darwin .deos/obj/vagrant .deos/obj/travis\
              .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis
  do
    [ ! -d "$path" ] && mkdir $path
  done
}

deos_clean() {
  path=.deos
  [ -d "$path" ] && rm -rf $path
}

deos_darwin() {
  deos_clean
  deos_init
  deos_bin
  #deos_venv "darwin"
  .deos/bin/darwin/deos
  EXIT_SUCCESS
}

deos() {
  case "${HOST_OS:-nil}" in
    Darwin)
      deos_darwin
    ;;
    Linux)
      EXIT_FAILURE
    ;;
    *)
      EXIT_FAILURE
    ;;
  esac
}

main() {
  deos
}

main
