document.addEventListener("DOMContentLoaded", initialize, false)

async function initialize() {

	await adminVerification() // await is yield

	// lesson learn, putting reload() here creates infinite stack of reload
	// window.location.reload()

	searchQuestion()

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

// so what we are doing is click event input triggers for each button input and we are using LIKE %input% to match questions in db
async function searchQuestion() {

	// initially to load all the questions, is one time event only
	sessionStorage.setItem("user_input", "")
	getQuestionsFromDb()

	var search_bar = document.createElement("input")
	search_bar.type = "search"
	search_bar.placeholder = "Search questions"

	search_bar.addEventListener("input", search, false)

	document.getElementById("search_bar").appendChild(search_bar)

	function search() {
		// get's the user typing
		console.log(this.value)

		sessionStorage.setItem("user_input", this.value)

		getQuestionsFromDb()
		
	}


	async function getQuestionsFromDb() {
		
		try {

			// so LIKE %""% returns all the questions from the postgres table, for the first time when page loads we are doing that 

			var search_res = await fetch("http://localhost:9005/search_questions/", {

				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({"user_input": sessionStorage.getItem("user_input")})

			})

			var body = await search_res.json()

	}

	catch (err) {
		console.error(err.message)
	}

	finally {

		displayQuestions(body)

		}
	}

}


async function displayQuestions(body) {

	var question_body = document.getElementById("questions")

	// we need to clear screen everytime, for each search

	question_body.innerHTML = ""

	for (var i = 0; i < body.length; i++) {

		// we need overall parent container to organize things in-line
		var parent_container = document.createElement("div")
		parent_container.id = `parent${i+1}`
		parent_container.className = `parent_display`


		// add each question to container and also add question id which acts as number
		var question_container = document.createElement("div")
		question_container.id = `question${i+1}`
		question_container.className = "hide_overflow"

		// let's create container for buttons seperately 
		var button_container = document.createElement("div")
		button_container.id = `button${i+1}`
		button_container.className = "button_display"


		// add each question to container and also add question id which acts as number
		// var question = document.createElement("pre")

		// for ellipsis to work the text has to be inside div
		question_container.textContent = i+1 + ". " + body[i].question


		// let's add edit button to take it to edit question page
		var edit_button = document.createElement("button")
		edit_button.textContent = "edit"
		edit_button.type = "button"
		edit_button.className = "action_button"

		edit_button.addEventListener("click", editQuestionEvent.bind(null, body[i]), false)

		// and delete button
		var delete_button = document.createElement("button")
		delete_button.textContent = "delete"
		delete_button.type = "button"
		delete_button.className = "action_button"

		delete_button.addEventListener("click", deleteQuestionEvent.bind(null, body[i]), false)

		// and also view button
		var view_button = document.createElement("button")
		view_button.textContent = "view"
		view_button.type = "button"
		view_button.className = "action_button"

		view_button.addEventListener("click", viewEvent.bind(null, body[i]), false)


		question_body.appendChild(parent_container)


		parent_container = document.getElementById(`parent${i+1}`)

		// question_container.appendChild(question)
		parent_container.appendChild(question_container)

		parent_container.appendChild(button_container)
		
		button_container = document.getElementById(`button${i+1}`)

		button_container.appendChild(view_button)

		button_container.appendChild(edit_button)

		button_container.appendChild(delete_button)


		}

}

// getting body response and id, this.id does not work and gets window when used with .bind to send param, no need serial id anymore as we iterating above
function viewEvent(body) {
	console.log(body)


	var dialog = document.createElement("dialog")
	dialog.id = `dialog${body.question_id}`
	

	// so when textContent += "\n" no works, use innerHTML += "<br>"

	// adding question
	dialog.innerHTML = "Question: " + body.question + "<br>"


	// adding problem statement
	 dialog.innerHTML += "Problem Statement: " + body.problem_statement + "<br>"


	// adding test cases
	dialog.innerHTML += "<hr>"

	 dialog.innerHTML += "Test Cases: " + "<br>"

	for (var [test_case_title, test_case_obj] of Object.entries(body.test_cases)) {

		dialog.innerHTML += "<hr>"
		
		dialog.innerHTML += test_case_title + "<br>"


		for ([key, value] of Object.entries(test_case_obj)) {
			

			dialog.innerHTML += key + " = " + value + "<br>"


		}
	}


	// adding examples
	dialog.innerHTML += "<hr>"

	dialog.innerHTML += "Examples: " + "<br>"

	for (var [example_num, example_obj] of Object.entries(body.examples)) {
		
		dialog.innerHTML += "<hr>"
		

		dialog.innerHTML += example_num + "<br>"


		for (var [key, value] of Object.entries(example_obj)) {

			dialog.innerHTML += value + "<br>"

		}

	}

	var hr = document.createElement("hr")
	dialog.appendChild(hr)

	var close_dialog = document.createElement("button")
	close_dialog.textContent = "close"

	// sending dialog id to let know system which is open for close
	close_dialog.addEventListener("click", closeModal.bind(null, dialog.id), false)

	dialog.appendChild(close_dialog)


	document.getElementById("main").appendChild(dialog)

	// so this modal thing is, restricting access to outside content while open
	document.getElementById(`dialog${body.question_id}`).showModal()


	function closeModal(id) {
		document.getElementById(`${id}`).close()

	}


}

// posting question to edit
async function editQuestionEvent(body) {

	try {

		// once again res must be given at endpoint
		var edit_question = await fetch("http://localhost:9005/post_question_to_edit_on_welcome_page", {

			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)

		})

	}

	catch (err) {

		console.error(err.message)

	}

	finally {

		window.location.href = "./edit_questions.html"

	}

}


// deleting method call here, with the question id
async function deleteQuestionEvent(body) {
	
	try {
		
	var delete_question = await fetch(`http://localhost:9005/delete_question/${body.question_id}`, {

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