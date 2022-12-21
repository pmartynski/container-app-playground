const express = require("express");
const { env } = require("node:process");
const app = express();
const healthcheck = require("maikai");

const openValue = env.OPEN_VALUE;
const secretValue = env.SECRET_VALUE;
const port = env.PORT || 3000;
const cosmosConnectionString = env.COSMOS_CONNECTION_STRING;

app.get("/", function (req, res) {
  res.writeHead(200, {
    "Content-Type": "text/html",
  });
  res.end(
    `<html>
  <head>
    <title>Container App Playground</title>
  </head>
  <body>
    <h1>Container App Playground</h1>
    <h2>Open config</h2>
    <p>${openValue}</p>
    <h2>Secret config</h2>
    <p>${secretValue}</p>
  </body>
</html>`
  );
});

const check = healthcheck({ path: "/healthcheck" });
check.addCheck(
  "cosmosdb",
  "connection",
  async () => {
    const cosmosDb = require("./cosmosdb");
    const status = await cosmosDb.getAvailability(cosmosConnectionString);

    return {
      status: status,
    };
  },
  { minCacheMs: 10000 }
);

app.use(check.express());

console.info(`Listening HTTP on port ${port}`);
app.listen(port);
