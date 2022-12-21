const CosmosClient = require('@azure/cosmos').CosmosClient;

module.exports.getAvailability = async (connectionString) => {
  const client = new CosmosClient(connectionString);
  const result = await client.databases
    .query('SELECT c.id FROM root c OFFSET 0 LIMIT 1')
    .fetchAll();
  client.dispose();
  return typeof result === 'object' && result !== null ? 'pass' : 'fail';
};
