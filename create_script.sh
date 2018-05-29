#!/bin/sh
clear
echo "Javascript file structure and npm setup script"
echo "This script can take a couple minutes to setup, please be patient."
echo "Are you sure you want to run it?[y/n]"
read console_answer
if [[ $console_answer == 'n' ]]; then
  echo "Script Setup cancelled."
  exit
fi

echo "Script execution started."

mkdir client
mkdir server
mkdir client/public client/src

touch public/index.html
mkdir public/css public/images public/js
touch public/css/main.css

echo "node_modules\nnpm-debug.log\nbundle.js" > .gitignore

echo "const config = {
  entry: \`\${__dirname}/client/src/app.js\`,
  output: {
    path: \`\${__dirname}\`,
    filename: 'bundle.js'
  },
  mode: 'development'
};

module.exports = config;" > webpack.config.js


mkdir client/src/helpers client/src/models client/src/views
mkdir client/src/models/specs
touch client/src/app.js
touch client/src/helpers/pub_sub.js

echo 'const PubSub = {
  publish: function (channel, payload) {
    const event = new CustomEvent(channel, {
      detail: payload
    });
    document.dispatchEvent(event);
  },

  subscribe: function (channel, callback) {
    document.addEventListener(channel, callback);
  }
};

module.exports = PubSub;' > client/src/helpers/pub_sub.js

touch client/src/helpers/request.js

echo "const Request = function (url) {
  this.url = url;
};

Request.prototype.get = function () {
  return fetch(this.url)
    .then((response) => response.json());
};

Request.prototype.delete = function (id) {
  return fetch(\`\${this.url}/\${id}\`, {
    method: 'DELETE'
  })
    .then((response) => response.json());
};

Request.prototype.post = function (payload) {
  return fetch(this.url, {
    method: 'POST',
    body: JSON.stringify(payload),
    headers: { 'Content-Type': 'application/json' }
  })
    .then((response) => response.json());
};

module.exports = Request;" > client/src/helpers/request.js

touch server/server.js
mkdir server/db
mkdir server/routers
touch server/db/seeds.js
touch server/routers/index_router.js

npm init -y
#npm install -D webpack webpack-cli nodemon
#npm install express mongodb mocha

echo "{
  \"name\": \"${PWD##*/}\",
  \"version\": \"1.0.0\",
  \"description\": \"\",
  \"main\": \"index.js\",
  \"scripts\": {
    \"start\": \"node server/server.js\",
    \"test\": \"mocha client/src/models/specs\",
    \"server:dev\": \"nodemon server/server.js\",
    \"build\": \"webpack -w\"
  },
  \"author\": \"\",
  \"license\": \"ISC\",
  \"devDependencies\": {
    \"nodemon\": \"^1.17.4\",
    \"webpack\": \"^4.7.0\",
    \"webpack-cli\": \"^2.1.3\"
  },
  \"dependencies\": {
    \"express\": \"^4.16.3\",
    \"mongodb\": \"^3.0.8\"
  }
}" > package.json

echo '<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title></title>
    <script src="/js/bundle.js"></script>
  </head>
  <body>

  </body>
</html>' > client/public/index.html

echo "const express = require('express');
const app = express();
const path = require('path');
const parser = require('body-parser');
const indexRouter = require('./routers/index_router.js');

const publicPath = path.join(__dirname, '../client/public');
app.use(express.static(publicPath));

app.use(parser.json());
app.use(indexRouter);

app.listen(3000, function () {
  console.log(\`Listening on port \${ this.address().port }\`);
});" > server/server.js

clear

echo "Script execution finished."
echo "Don't forget to run:"
echo "mongod in a new tab"
echo "mongo < server/db/seeds.js in a new tab"
echo "npm run build in a new tab"
echo "npm run server:dev in a new tab"
echo "Take in my the index router is created by completly empty."
echo "After this you are ready to develop! Have Fun"
