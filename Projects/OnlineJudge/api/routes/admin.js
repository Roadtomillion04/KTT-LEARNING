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


module.exports = router