const express = require('express')
const { env } = require('node:process') 
const app = express()

const openValue = env['OPEN_VALUE']
const secretValue = env['SECRET_VALUE']
const port = env['PORT'] || 3000

app.get('/', function (req, res) {
  res.send(`open: ${openValue}\nsecret: ${secretValue}`)
})

console.info(`Listening HTTP on port ${port}`)
app.listen(port)