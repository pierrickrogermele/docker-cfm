#!/bin/sh

prg=$1
shift
cd /sources/cfmid
wine $prg "$@"
