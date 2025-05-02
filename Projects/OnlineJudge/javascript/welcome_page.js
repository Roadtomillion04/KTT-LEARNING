document.addEventListener("DOMContentLoaded", displayAllQuestions, false)

async function displayAllQuestions() {

	try {
	var get_all_questions = await fetch("http://localhost:9002/get_all_questions", {

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

		question.addEventListener("click", addClickEvent.bind(null, body[i], body[i].question_id), false)

		test.appendChild(question)

		}

	}

	catch (err) {
		console.error(err.message)
	}

}

// getting body response and id, this.id does not work and gets window when used with .bind to send param
function addClickEvent(body, id) {
	console.log(id, body) // returns id of the clicked element

	// get right side
	var info_body = document.getElementById("question_info")

	// let's iterate the body and find match of the id
	// for (var i = 0; i < body.length; i++) {
		// if (body[i].question_id == id) {
			// match found and create elements to display

	// clearing screen everytime to avoid appending
	info_body.innerHTML = ""

	// adding question
	var question = document.createElement("h2")
	question.innerHTML = body.question
	info_body.appendChild(question)

	// adding <hr> for everyline for good visuals
	var hr = document.createElement("hr")
	info_body.appendChild(hr)

	// adding problem statement
	var problem_statement = document.createElement("h4")
	problem_statement.innerHTML = body.problem_statement
	info_body.appendChild(problem_statement)

	var hr = document.createElement("hr")
	info_body.appendChild(hr)

	// adding test cases
	for (var [test_case_title, test_case_obj] of Object.entries(body.test_cases)) {

		var test_cases = document.createElement("pre")
		
		test_cases.innerHTML = test_case_title

		info_body.appendChild(test_cases)

		for ([key, value] of Object.entries(test_case_obj)) {
			var new_pair = document.createElement("pre")

			new_pair.innerHTML = key + " = " + value

			info_body.appendChild(new_pair)

		}
	}

	// tip you have to CREATE element everytime otherwise it updates to last position
	hr = document.createElement("hr")
	info_body.appendChild(hr)

	// adding examples
	for (var [example_num, example_obj] of Object.entries(body.examples)) {
		
		var examples = document.createElement("pre")
		examples.innerHTML = example_num

		info_body.appendChild(examples)

		for (var [key, value] of Object.entries(example_obj)) {
			var new_pair = document.createElement("pre")

			new_pair.innerHTML = value

			info_body.appendChild(new_pair)
		}

	}
	hr = document.createElement("hr")
	info_body.appendChild(hr)

}