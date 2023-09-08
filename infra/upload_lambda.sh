#!/bin/bash

lambda_name=$1
zip_file_name="${lambda_name}.zip"

echo "-> Script executado por init.sh"
bucket_name=$(terraform output -raw bucket_name)
cd ..

bucket_dir=s3://"${bucket_name}/apps/${lambda_name}/"

7z a "${zip_file_name}" ../apps/${lambda_name}/index.js
echo "-> Arquivo ${zip_file_name} compactado"

aws s3 cp "${zip_file_name}" "${bucket_dir}" --sse AES256
echo "-> Arquivo enviado para o bucket -> ${bucket_dir}${zip_file_name}"

rm -f "${zip_file_name}"