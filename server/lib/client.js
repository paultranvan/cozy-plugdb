(function() {
  var DS_PORT, client, request, _ref;

  request = require('request-json-light');

  DS_PORT = process.env.DS_PORT || 9101;

  client = request.newClient("http://localhost:" + DS_PORT);

  if ((_ref = process.env.NODE_ENV) === "production" || _ref === "test") {
    client.setBasicAuth(process.env.NAME, process.env.TOKEN);
  } else {
    client.setBasicAuth(Math.random().toString(36), "token");
  }

  module.exports = client;

}).call(this);