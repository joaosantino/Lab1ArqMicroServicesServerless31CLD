#!/usr/bin/env python
"""
  Este Python Script recebe como argumento nomes de buckets
  Ex de execução: s3_delete.py nome_bucket_1 nome_bucket_2 nome_bucket_n
"""

import sys
import boto3

s3 = boto3.resource('s3')

for index in range(1, len(sys.argv)):
  bucket_name = sys.argv[index]
  print(bucket_name)
  s3_bucket = s3.Bucket(sys.argv[index])
  s3_bucket.object_versions.delete()
  s3_bucket.delete()
