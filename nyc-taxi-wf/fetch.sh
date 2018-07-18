#!/bin/bash
set -euxo pipefail

IN=$1
OUT=$2
DIR=$(pwd)/.wget

# create temp directory
mkdir -p $DIR

# download data
wget $IN --directory-prefix=$DIR

# compress data
gzip $DIR/*

# move data to HDFS
hdfs dfs -put -f $DIR/* $OUT

# delete temp directory
rm $DIR
