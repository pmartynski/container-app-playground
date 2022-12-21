const CosmosClient = require("@azure/cosmos").CosmosClient;

module.exports.getAvailability = async (connectionString) => {
  const client = new CosmosClient(connectionString);

  try {
    const result = await client.databases
      .query("SELECT c.id FROM root c OFFSET 0 LIMIT 1")
      .fetchAll();
    return typeof result === "object" && result !== null ? "pass" : "fail";
  } catch (error) {
    return {
      status: "fail",
      output: {
        body: JSON.stringify(error.body),
      },
    };
  } finally {
    client.dispose();
  }
};
