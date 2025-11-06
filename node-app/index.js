const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('🚀 Hello from Node.js App deployed via Docker!');
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
