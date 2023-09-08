
const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  console.log("Iniciando Lambda")
  let body;
  let statusCode = 200;
  const tableName = "http-crud-tutorial-items"
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    switch (event.routeKey) {
      case "DELETE /items/{id}":
        console.log("DELETE /items/{id}")
        await dynamo
          .delete({
            TableName: tableName,
            Key: {
              id: event.pathParameters.id
            }
          })
          .promise();
        body = `Deleted item ${event.pathParameters.id}`;
        console.log("Sucesso ao interagir com a base de dados!")
        break;
      case "GET /items/{id}":
        console.log("GET /items/{id}")
        body = await dynamo
          .get({
            TableName: tableName,
            Key: {
              id: event.pathParameters.id
            }
          })
          .promise();
        console.log("Sucesso ao interagir com a base de dados!")
        break;
      case "GET /items":
        console.log("GET /items")
        body = await dynamo.scan({ TableName: tableName }).promise();
        console.log("Sucesso ao interagir com a base de dados!")
        break;
      case "PUT /items":
        console.log("PUT /items")
        let requestJSON = JSON.parse(event.body);
        await dynamo
          .put({
            TableName: tableName,
            Item: {
              id: requestJSON.id,
              price: requestJSON.price,
              name: requestJSON.name
            }
          })
          .promise();
        console.log("Sucesso ao interagir com a base de dados!")
        body = `Put item ${requestJSON.id}`;
        break;
      default:
        console.log("Método HTTP não suportado!")
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
    console.log("Erro durante a execução")
  } finally {
    body = JSON.stringify(body);
  }
  console.log("Response: ", body)
  console.log("Finalizando Lambda")
  return {
    statusCode,
    body,
    headers
  };
};

