#!/bin/bash

initial_message="Apenas prossiga caso tenha lido o README.md...."
default_message="Pressione qualquer tecla para continuar...."

read_from_user(){
    read -p "${1}" my_var 
}
read_from_user "${initial_message}"
# shellcheck disable=SC2164
npm -g install js-beautify

cd first_config/
cp -rf ../config_stack/variables.tf .

echo -e "\n-----------------------------Criando recursos iniciais-------------------------------"
terraform init
terraform apply -auto-approve

bucket_name=$(terraform output -raw bucket_name)
id_account=$(terraform output -raw id_account)
aws_region=$(terraform output -raw aws_region)
echo "--------------------------------------------------------------------------------------"

echo -e "\n-----------------------------Recursos Iniciais Criados-------------------------------"
echo "BucketName -> ${bucket_name}"
echo "--------------------------------------------------------------------------------------"

echo -e "\n------------------------Atualizando arquivos com os dados corretos-------------------"
cp -rf ../config_stack/* .
sed -i "s/ID_ACCOUNT/${id_account}/g" iam/policies/*.json
sed -i "s/AWS_REGION/${aws_region}/g" iam/policies/*.json
echo "--------------------------------------------------------------------------------------"

echo -e "\n------------------------Enviando aplicações para o Bucket criado---------------------"
../upload_lambda.sh http-crud-tutorial-function true > ../output_upload_lambda.txt
rm -f ../output_upload_lambda.txt
echo "--------------------------------------------------------------------------------------"

echo -e "\n----------------------Criando os recursos restantes da stack-------------------------"
terraform apply -auto-approve
echo "--------------------------------------------------------------------------------------"

echo -e "\n--------------------Setando a variavel de ambiente INVOKE_URL------------------------"
export INVOKE_URL=$(terraform output -raw api)
table_name=$(terraform output -raw table_name)

echo -e "\n--------------------Realizando PUT /items em ${INVOKE_URL}------------------------"
read_from_user "${default_message}"
curl -X "PUT" -H "Content-Type: application/json" -d "{
    \"id\": \"fsmafj241\",
    \"price\": 100000,
    \"name\": \"joaosantino\"
}" $INVOKE_URL/items
echo -e "\n--------------------------------------------------------------------------------------------------"

echo -e "\n--------------------Realizando GET /items em ${INVOKE_URL}------------------------"
curl -s $INVOKE_URL/items | js-beautify
echo -e "\n-----------------------------------------------------------------------------------------------"

echo -e "\n--------------------Realizando GET /items/{id} em ${INVOKE_URL}------------------------"
curl -s $INVOKE_URL/items/fsmafj241 | js-beautify
echo -e "\n-------------------------------------------------------------------------------------------------"

echo -e "\n--------------------Realizando DELETE /items/{id} em ${INVOKE_URL}------------------------"
read_from_user "${default_message}"
curl -X "DELETE" $INVOKE_URL/items/fsmafj241
echo -e "\n----------------------------------------------------------------------------------------------------"

echo -e "\n--------------------Confirmando que tudo foi deletado em ${table_name}------------------------"
curl -s $INVOKE_URL/items | js-beautify
echo -e "\n----------------------------------------------------------------------------------------------------"


