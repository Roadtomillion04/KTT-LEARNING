var express = require('express')
var router = express.Router()
var pool = require('../postgres/db.js')



// check admin table, okay so :id gets only one param, to get the query, do this
router.get("/check_admin_credentials", async function (req, res) {
	
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


router.post("/test_config", async function (req, res) {

		var body = req.body

		var query = `INSERT INTO TEST_CONFIG (test_id, question_count, start_time, end_time, test_date) VALUES ('${body.test_id}', '${body.question_count}', '${body.start_time}', '${body.end_time}', '${body.test_date}')`

		var insert_data = await pool.query(query)

		res.json("ok!")

})

// let's fetch the last inserted values as the configs for the next test
router.get("/get_configs", async function (req, res) {

	var query = `SELECT * FROM TEST_CONFIG ORDER BY creation_id DESC LIMIT 1`

	var get_row = await pool.query(query)

	res.json(get_row.rows)

})


module.exports = router