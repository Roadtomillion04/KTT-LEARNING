// var app = require('express')()
// is shortcut for 
var express = require('express')
var app = express()
var cors = require('cors')
var pool = require('./db')

app.use(express.json()) // to get req.body
app.use(cors()) // cors error (HTTP security protocol) strikes if not set while using fetch, cors need to be set for resource sharing across different media 

//
var get_chosen_question = ""
var client_generated_token = ""

// digital ocean jwt tutorial
var jwt = require('jsonwebtoken')

// console.log(require('crypto').randomBytes(64).toString('hex')) -> this was the code used to generate the secret token

// dotenv sole purpose is to load environment variables from a .env file into process.env and .env is no visible in file system lol
var dotenv = require('dotenv')
dotenv.config()
var secret_key = process.env.SECRET_TOKEN
// console.log(process.env.SECRET_TOKEN)


function generateAccessToken(username) {
  return jwt.sign(username, secret_key, { expiresIn: '1800s' })
}

// endpoint for registering user from Login Page
app.post("/create_new_user", async function (req, res) {

	try {

	// req.body is an object type
	var body = req.body

	// does not work without `as identifier`
	var time_stamp = await pool.query(`SELECT current_date as date, current_time as now`)

	console.log(JSON.stringify(time_stamp.rows[0].date).slice(1, 11), JSON.stringify(time_stamp.rows[0].now.slice()));

	var query = `INSERT INTO user_register (first_name, last_name, email, department, roll_no, user_password, registration_time) 
VALUES ('${body.first_name}', '${body.last_name}', '${body.email}', '${body.department}', '${body.roll_no}', '${body.password}', '${JSON.stringify(time_stamp.rows[0].date).slice(1, 11) + " " + time_stamp.rows[0].now}');`

		var new_add = await pool.query(query)
		// res.json(new_add)

		// so umm let's call generatetoken function with the username
		var token = await generateAccessToken( {username: body.first_name} )
		
		res.json({token: token})
	
	} 
	
	catch (err) {
		console.error(err.message)
	}

})

// getting token from login page in client side and store it in global var,
// app.post("/user_generated_token", async function (req, res) {

// 		try {


// 			res.json("ok!")

// 		}

// 		catch (err) {
// 			console.error(err.message)
// 		}

// })

// 
function authenticateToken(req, res, next) {

	// well actually sending localStorage as a header seems to work, as each google account/incognito(but if you open multiple incognito they all share same localStorage) has its own localStorage/cookie/session
	var token = req.headers.user_token

  if (token == null) {
  		res.json({user: "invalid"})
  	}

  jwt.verify(token, secret_key, function (err, user) {

  if (err) return res.json({user: "invalid"})

  req.user = user

	console.log(req.user)

  next()

  })

}


// so the async function get executed after authenticateToken is done
app.get("/check_user", authenticateToken, async function (req, res) {

	try {

		res.json({user: "valid"})

		

	// var get_users = await pool.query(`SELECT * FROM user_register;`)
	// res.json(get_users.rows) // responds in json format
	
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

// well get the question for default.html page, since we know which question to pick from /question_selected we gotta access the question from there
app.get("/get_question", async function (req, res) {
	try {
		// okay so declaring get_chosen_question a global variable and update it on post (/question_selected) and while getting it here it work!
		var get_question = await get_chosen_question

		res.json(get_question)

	}

	catch (err) {
		console.error(err.message)
	}
})


app.get("/get_all_questions", async function (req, res) {

		var query = `SELECT * FROM INTERVIEW_QUESTIONS`

		var get_all_questions = await pool.query(query)

		res.json(get_all_questions.rows)
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

app.get("/header_check", async function (req, res) {

	try {

		var a = req.headers.is_admin
		console.log(a)

		res.redirect("")

	}

	catch (err) {
		console.error(err.message)
	}
})

// get 5 questions randomly for the user to take test
app.get("/test_questions", async function (req, res) {

		try {
			// this random selection has to be one time event for new account, for now I'll store all the client tokens in array, not sure how effective it is, Update: handling this in client side

				// ehh just question is enough
				var query = `SELECT question FROM INTERVIEW_QUESTIONS ORDER BY random() LIMIT 5`

				var get_five_questions = await pool.query(query)

				res.json(get_five_questions.rows)


		}

		catch (err) {
			console.error(err.message)
		}

})


// so getting the pressed question on test page and let's try to update default.html accordingly
app.post("/question_selected", async function (req, res) {

		try {

			var body = req.body

			console.log(body)
			
			// so now that we know which question is pushed next let's select * db and get the rest of the columns

			get_chosen_question = await pool.query(`SELECT * FROM INTERVIEW_QUESTIONS WHERE question = '${body.question}';`)

			get_chosen_question = get_chosen_question.rows

			console.log(get_chosen_question)

			// console.log(get_question_db.rows)
			res.json("recieved")

		}

		catch (err) {
			console.log(err.message)
		}

} )

// delete question in db
app.delete("/delete_question/:id", async function (req, res) {

		try {
		// destructing
		var { id } = req.params

		// just slice to remove :
		id = id.slice(1,)


		var query = `DELETE FROM INTERVIEW_QUESTIONS WHERE question_id = ${id}`

		var delete_question = await pool.query(query)

		res.json("ok!")

		}

		catch (err) {
			console.error(err.message)
		}


} )


app.listen(9005, function () {})