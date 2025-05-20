// var app = require('express')()
// is shortcut for 
var express = require('express')
var app = express()
var cors = require('cors')
var pool = require('./postgres/db.js')


var session = require("express-session")


// reference express-session-npm
app.use(session({
	secret: "secret",
	resave: false,
	saveUninitialized: true
}))


// app.use(function (req, res, next) {

// 	if (req.session.get_question)

// })


app.use(express.json()) // to get req.body
app.use(cors()) // cors error (HTTP security protocol) strikes if not set while using fetch, cors need to be set for resource sharing across different media 


// reference predroTech express routes
var user_route = require("./routes/user")
var admin_route = require("./routes/admin")
var questions_route = require("./routes/questions")

app.use("/", user_route)
app.use("/", admin_route)
app.use("/", questions_route)


app.listen(8999, function () {})