#!/bin/bash

initial_message="Tem certeza que deseja deletar tudo? Pressione ENTER para continuar ou CTRL + C para sair...."

read_from_user(){
    read -p "${1}" my_var 
}
read_from_user "${initial_message}"

# shellcheck disable=SC2164
cd first_config/

bucket_name=$(terraform output -raw bucket_name)

echo -e "\n-----------------------------Removendo o bucket ${bucket_name} do Destroy-------------------------------"
terraform state rm aws_s3_bucket.bucket

echo -e "\n-----------------------------Destruindo todos os recursos com exceção do bucket ${bucket_name}-------------------------------"
sleep 30
terraform destroy -auto-approve

rm -rf iam
rm -rf .terraform*
rm -f terraform.*
rm -f iam.tf
rm -f lambda.tf
rm -f dynamodb.tf
rm -f variables.tf
rm -f apigateway.tf

python -m pip install --upgrade pip --quiet
python -m pip install boto3 --quiet --user

echo -e "\n--------------------------------- -Deletando o bucket ---------------------------------------------"
python ../s3_delete.py ${bucket_name}
echo "-----------------------------------------------------------------------------------------------------"