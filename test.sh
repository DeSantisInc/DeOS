#!/usr/bin/env bash

while getopts "c:" OPT; do
  case "$OPT" in
    c) if      [ "$OPTARG" = "hello"   ]; then echo $OPTARG
       else if [ "$OPTARG" = "hellos"  ]; then echo $OPTARG
       else if [ "$OPTARG" = "helloss" ]; then echo $OPTARG
       else                                    echo 'else'
       fi; fi; fi ;;
    ?) echo "fail" ;;
  esac
done
