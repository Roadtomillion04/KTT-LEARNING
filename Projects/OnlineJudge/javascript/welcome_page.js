document.addEventListener("DOMContentLoaded", displayAllQuestions, false)

async function displayAllQuestions() {

	try {
	var get_all_questions = await fetch("http://localhost:9001/get_questions", {

		method: "GET",
		headers: {"Content-Type": "application/json"}
	})

	var body = await get_all_questions.json()

	var test = document.getElementById("questions")

	for (var i = 0; i < body.length; i++) {
		// add each question to container and also add question id which acts as number
		var question = document.createElement("pre")

		question.textContent = body[i].question_id + ". " + body[i].question
		question.className = "can_click"
		question.style.fontSize = "2em"
		// let's add id to track which one is clicked
		question.id = body[i].question_id

		question.addEventListener("click", addClickEvent.bind(null, body, body[i].question_id), false)

		test.appendChild(question)

	}


	}

	catch (err) {
		console.error(err.message)
	}

}

// getting body response and id,, this.id does not work and gets window when used with .bind to send param
function addClickEvent(body, id) {
	console.log(id) // returns id of the clicked element

	// get right side
	var info_body = document.getElementById("question_info")

	// let's iterate the body and find match of the id
	for (var i = 0; i < body.length; i++) {
		if (body[i].question_id == id) {
			// match found and create elements to display

			var question = document.createElement("h2")
			var problem_statement = document.createElement("h4")
			var test_cases = document.createElement("pre")
			
		}
	}



}