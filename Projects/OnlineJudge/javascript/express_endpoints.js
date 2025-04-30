// var app = require('express')()
// is shortcut for 
var express = require('express')
var app = express()
var cors = require('cors')
var pool = require('./db')
// var query = require('./login')

app.use(express.json()) // to get req.body
app.use(cors()) // cors error strikes if not set while using fetch


// endpoint for registering user from Login Page
app.post("/user_register", async function (req, res) {

	// req.body is an object type
	var body = req.body

	// does not work without `as identifier`
	var time_stamp = await pool.query(`SELECT current_date as date, current_time as now`)

	console.log(JSON.stringify(time_stamp.rows[0].date).slice(1, 11), JSON.stringify(time_stamp.rows[0].now.slice()));

	var query = `INSERT INTO user_register (first_name, last_name, email, department, roll_no, user_password, registration_time) 
VALUES ('${body.first_name}', '${body.last_name}', '${body.email}', '${body.department}', '${body.roll_no}', '${body.password}', '${JSON.stringify(time_stamp.rows[0].date).slice(1, 11) + " " + time_stamp.rows[0].now}');`

	try {
		var new_add = await pool.query(query)
		// res.json(new_add)
	} 
	catch (err) {
		console.error(err.message)
	}

})

// get registered users
app.get("/get_users", async function (req, res) {

	try {
	var get_users = await pool.query(`SELECT * FROM user_register;`)
	res.json(get_users.rows) // responds in json format
	}
	catch (err) {
		console.error(err.message)
	}

})

// add questions to postgres
app.post("/add_question", async function (req, res) {

	var body = req.body

	console.log(body)

	// we know the last value is going to be output cause languagles like Java no 2 return and step is most important part here to segerate the combined test cases in array
	// console.log(body.test_case_values[0])

	var query = `INSERT INTO INTERVIEW_QUESTIONS (question, problem_statement, test_cases, examples) VALUES ('${body.question}', '${body.problem_statement}', '${JSON.stringify(body.test_cases)}', '${JSON.stringify(body.examples)}');`

	try {
		var new_add = await pool.query(query)
		// res.json(new_add)
	} 

	catch (err) {
		console.error(err.message)
	}
})

// get questions from postgres
app.get("/get_questions", async function (req, res) {
	try {
		var get_questions = await pool.query("SELECT * FROM interview_questions")

		res.json(get_questions.rows)

	}

	catch (err) {
		console.error(err.message)
	}
})

// check admin table, okay so :id gets only one param, to get the query, do this
app.get("/check_admin_credentials", async function (req, res) {
	
	try {
		var name = await req.query.username
		var password = await req.query.password
		console.log(name, password)

		// now let's check if user actually exist in db
		var query = `SELECT * FROM ADMIN WHERE username = '${name}' and admin_password = '${password}';`

		var check_exists = await pool.query(query)

		res.json(check_exists.rows)
		
		}

	catch (err) {

		console.log(err.message)

		}
	
	}

)


app.listen(9001, function () {})
