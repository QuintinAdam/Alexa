
// var insult;
var getInsult = function(insult) {

  var http = require("http");
  var url = "http://pleaseinsult.me/api?severity=random";
  var request = http.get(url, function (response) {
      var buffer = "",
          data;

      response.on("data", function (chunk) {
          buffer += chunk;
      });

      response.on("end", function (err) {

          data = JSON.parse(buffer);
          insult(data);
      });

  });
};
getInsult(function(insult) {
  // use the return value here instead of like a regular (non-evented) return value
  console.log(insult.insult);
});

