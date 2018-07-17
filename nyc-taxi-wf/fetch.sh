$IN=$1
$OUT=$2
$DIR=output

# create temp directory
mkdir -p $DIR

# download data
wget $1 --directory-prefix=$DIR

# move data to HDFS
hdfs dfs -put -f $DIR/* $2

# delete temp directory
rm $DIR