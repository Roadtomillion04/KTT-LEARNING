
function serve_http() {
	var http = require("http")

	var server = http.createServer(function(request, response) {

		if (request.url == "/"){
			response.write("request recieved")
			response.end()
			}

		if (request.url == "/home") {
			response.write("welcome to home page!")
			response.end()
			}	

		if (request.url == "/files") {
			var serveStatic = require("serve-static")
			var finalHandler = require("finalhandler")

			var serve = serveStatic("../ktt")
			serve(request, response, finalHandler(request, response))
		}

		}
	)

	server.listen(8888)
}


var express = require("express")
var app = express()

app.get("/", function (request, response) {
	response.send("Request Recieved")
})

app.get("/home", function (request, response) {
	response.send("welcome to home page")
})

app.listen(8889)
