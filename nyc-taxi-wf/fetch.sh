set -xeo pipefail

IN=$1
OUT=$2
DIR=output

# create temp directory
mkdir -p $DIR

# download data
wget $IN --directory-prefix=$DIR

# move data to HDFS
hdfs dfs -put -f $DIR/* $OUT

# delete temp directory
rm $DIR
