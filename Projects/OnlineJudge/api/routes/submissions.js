var express = require('express')
var router = express.Router()
var pool = require('../postgres/db.js')


// user submitting the test
router.post("/submit_answers", async function (req, res) {

		var body = req.body

		var query = `INSERT INTO SUBMISSIONS (test_id, roll_no, questions_passed) VALUES ('${body.test_id}', '${body.roll_no}', '${JSON.stringify(body.questions_passed)}')`

		try {

		var post_submission = await pool.query(query)

		res.json("ok!")

		}

		catch (err) {
			console.error(err.message)
		}

})

// getting all submissions
router.get("/get_submissions", async function (req, res) {

	try {

	var query = `SELECT * FROM SUBMISSIONS`

	var get_all_submissions = await pool.query(query)

	res.json(get_all_submissions.rows)

	}

	catch (err) {
		console.error(err.message)
	}

})

module.exports = router