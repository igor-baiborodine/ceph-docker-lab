#!/bin/bash
set -e

buckets_count=$1
s3cfg_file=$2
source_folder=$3
echo "buckets_count: $buckets_count, s3cfg_file: $s3cfg_file, source_folder: $source_folder"

for i in $(seq 1 "$buckets_count")
do
  bucket_name="b_PHOTOS_$i"
  echo "Creating bucket $bucket_name..."
  s3cmd -c "$s3cfg_file" mb "s3://$bucket_name"

  echo "Copying files to bucket $bucket_name..."
  s3cmd -c "$s3cfg_file" put -r "$source_folder" "s3://$bucket_name" &
  sleep 1
done