var express = require('express')
var router = express.Router()
var pool = require('../postgres/db.js')

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


// endpoint for registering user from Login Page
router.post("/create_new_user", async function (req, res) {

	try {

	// req.body is an object type
	var body = req.body

	// does not work without `as identifier`
	var time_stamp = await pool.query(`SELECT current_date as date, current_time as now`)

	// instead of this, I could have just set `default now()` in the column creation..
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


// so the async function get executed after authenticateToken is done
router.get("/check_user", authenticateToken, async function (req, res) {

	try {

		res.json({user: "valid"})

		

	// var get_users = await pool.query(`SELECT * FROM user_register;`)
	// res.json(get_users.rows) // responds in json format
	
	}
	
	catch (err) {
		console.error(err.message)
	}

})


module.exports = router