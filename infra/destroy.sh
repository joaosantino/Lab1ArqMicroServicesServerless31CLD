#!/bin/bash

initial_message="Tem certeza que deseja deletar tudo? Pressione ENTER para continuar ou CTRL + C para sair...."

read_from_user(){
    read -p "${1}" my_var 
}
read_from_user "${initial_message}"

# shellcheck disable=SC2164
cd first_config/

bucket_name=$(terraform output -raw bucket_name)

echo -e "\n-----------------------------Deletando todos os recursos-------------------------------"
terraform state rm aws_s3_bucket.bucket
terraform destroy -auto-approve

rm -rf iam
rm -rf .terraform*
rm -f terraform.*
rm -f iam.tf
rm -f lambda.tf
rm -f dynamodb.tf
rm -f variables.tf
rm -f apigateway.tf

echo "----------------------------------------------------------------------------------------"

echo -e "\n------------------------Deletando os itens do bucket ${bucket_name}------------------------------"
../delete_all_s3_objects.sh ${bucket_name}
echo -e "\n-----------------------------------------------------------------------------------------------------"

echo -e "\n----------------------------Deletando os recursos restantes----------------------------"
aws s3api delete-bucket --bucket ${bucket_name} > bucket_delete.json
rm -f *_delete.json
echo -e "\n---------------------------------------------------------------------------------------"