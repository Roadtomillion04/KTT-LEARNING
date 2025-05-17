var express = require('express')
var router = express.Router()
var pool = require('../postgres/db.js')

// I forgot server canno't access client side storage

// for display in default page
var get_question_from_test_page = ""

// to edit on edit question page
var get_question_from_welcome_page = ""

// add questions to postgres
router.post("/add_question", async function (req, res) {

	var body = req.body

	console.log(body)

	// we know the last value is going to be output cause languagles like Java no 2 return and step is most important part here to segerate the combined test cases in array
	console.log(JSON.stringify(body.test_cases))

	var query = `INSERT INTO INTERVIEW_QUESTIONS (question, problem_statement, test_cases, examples) VALUES ('${body.question}', '${body.problem_statement}', '${JSON.stringify(body.test_cases)}', '${JSON.stringify(body.examples)}');`

	try {
		var new_add = await pool.query(query)
		res.json("ok!")
	} 

	catch (err) {
		console.error(err.message)
	}
})


// well get the question for default.html page, since we know which question to pick from /question_selected we gotta access the question from there
router.get("/get_question_to_display_on_default_page", async function (req, res) {
	try {
		// okay so declaring get_question_from_test_page a global variable and update it on post (/question_selected) and while getting it here it work!
		var question = await get_question_from_test_page

		res.json(question)

	}

	catch (err) {
		console.error(err.message)
	}
})


router.get("/get_all_questions", async function (req, res) {

		var query = `SELECT * FROM INTERVIEW_QUESTIONS`

		var get_all_questions = await pool.query(query)

		res.json(get_all_questions.rows)
})


// get 5 questions randomly for the user to take test
router.get("/test_questions", async function (req, res) {

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
router.post("/post_question_clicked_on_test_page", async function (req, res) {

		try {

			var body = req.body

			console.log(body)
			
			// so now that we know which question is pushed next let's select * db and get the rest of the columns

			get_question_from_test_page = await pool.query(`SELECT * FROM INTERVIEW_QUESTIONS WHERE question = '${body.question}';`)

			get_question_from_test_page = get_question_from_test_page.rows


			// console.log(get_question_db.rows)
			res.json("recieved")

		}

		catch (err) {
			console.log(err.message)
		}

} )


// PUT part: getting clicked question first from the welcome_page
router.post("/post_question_to_edit_on_welcome_page", async function (req, res) {

	try {

			var body = req.body

			console.log(body)

			get_question_from_welcome_page = req.body

			res.json("ok!")

	}

	catch (err) {

		console.error(err.message)

	}


})

router.get("/get_question_to_edit", async function (req, res) {

		try {

				var question = await get_question_from_welcome_page

				res.json(question)

		}

		catch (err) {

			console.error(err.message)

		}

})


router.put("/update_question/:id", async function (req, res) {

		try {

		var { id } = req.params
		var body = req.body

		// console.log("id", id)
		// console.log("body", body)

		// to update multiple columns use set col1 = val, col2 = val
		var query = `UPDATE INTERVIEW_QUESTIONS SET question = '${body.question}', problem_statement = '${body.problem_statement}', test_cases = '${JSON.stringify(body.test_cases)}', examples = '${JSON.stringify(body.examples)}' WHERE question_id = '${id}';`

		var update = await pool.query(query)

		res.json("done!")

		}

		catch (err) {

			console.error(err.message)

		}

})



// delete question in db, after : is params
router.delete("/delete_question/:id", async function (req, res) {

		try {
		// destructing
		var { id } = req.params


		var query = `DELETE FROM INTERVIEW_QUESTIONS WHERE question_id = ${id};`

		var delete_question = await pool.query(query)

		res.json("ok!")

		}

		catch (err) {
			console.error(err.message)
		}


} )



// let's try search questions based on user input in db
router.post("/search_questions", async function (req, res) {

		try {

			var body = req.body

			var query = `SELECT * FROM INTERVIEW_QUESTIONS WHERE question LIKE '%${body.user_input}%'`

			var search_questions = await pool.query(query)

			res.json(search_questions.rows)
		
		}

		catch (err) {

			console.error(err.message)

		}


})

module.exports = router
