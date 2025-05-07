document.addEventListener("DOMContentLoaded", initialize, false)

async function initialize() {

	await adminVerification() // await is yield
	displayAllQuestions()
}

async function adminVerification() {
	// var admin_status = await fetch("http://localhost:9005/check_admin", {

	// 	// okay so don't be confused with the GET method here, we are sending sessionStorage in headers, it'll recive in express
	// 	method: "GET",
	// 	headers: {"Content-Type": "application/json", "is_admin": sessionStorage.getItem("is_admin")}

	// })

	// var res = await admin_status.json()

	// don't do it in a hard way lol
	var is_admin = sessionStorage.getItem("is_admin")

	if (is_admin != "yes") {
		alert("not authorized")

		// redirect
		window.location.replace("./login.html")
	}

}

async function displayAllQuestions() {

	try {
	var get_all_questions = await fetch("http://localhost:9005/get_all_questions", {

		method: "GET",
		headers: {"Content-Type": "application/json"}
	})

	var body = await get_all_questions.json()

	var test = document.getElementById("questions")

	for (var i = 0; i < body.length; i++) {
		// add each question to container and also add question id which acts as number
		var question = document.createElement("pre")

		question.textContent = i+1 + ". " + body[i].question
		question.className = "can_click"
		question.style.fontSize = "2em"


		question.addEventListener("click", addClickEvent.bind(null, body[i]), false)

		test.appendChild(question)

		}

	}

	catch (err) {
		console.error(err.message)
	}

}

// getting body response and id, this.id does not work and gets window when used with .bind to send param, no need serial id anymore as we iterating above
function addClickEvent(body) {
	console.log(body)

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

	var delete_button = document.createElement("button")
	delete_button.textContent = "delete"
	delete_button.type = "button"

	delete_button.addEventListener("click", deleteQuestionEvent.bind(null, body), false)

	info_body.appendChild(delete_button)

}

// simple delete method call here, with the question id
async function deleteQuestionEvent(body) {
	
	try {
	var delete_question = fetch(`http://localhost:9005/delete_question/:${body.question_id}`, {

		method: "DELETE",
		headers: {"Content-Type": "application/json"}
		})
	
	}

	catch (err) {
		console.error(err.message)
	}

	finally {
		// so after the deletion just refresh the page for an update
		window.location.reload()
	}

}

function logoutAdmin() {

	// on logging out let's delete sessionStorage before redirecting
	sessionStorage.removeItem("is_admin")

	window.location.href = "./admin_page.html"

}