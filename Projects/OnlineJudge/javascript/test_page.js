document.addEventListener("DOMContentLoaded", loadData, false)

// so before loading question, we are checking jwt token exists from login page
async function loadData() {
	await tokenVerification() // await here is like yield
	selectFiveQuestions()
}


async function tokenVerification() {
	
	var token_verify = await fetch("http://localhost:9002/check_user", {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	var res = await token_verify.json()

	console.log(res)

	if (res.user == "invalid") {
		alert("who are you?")

		// redirect
		window.location.href = "./login.html"
	}
}

async function selectFiveQuestions() {

	try {
	var get_five_questions = await fetch("http://localhost:9002/test_questions", {

		method: "GET",
		headers: {"Content-Type": "application/json"}
	})

	var body = await get_five_questions.json()


	var question_container = document.getElementById("questions")

	for (var i = 0; i < body.length; i++) {

		// // so inorder to display question and button in same line, let's just create individual div for each iteration 

		// var div = document.createElement("div")
		// div.id = `div${i}`

		// // set this to flex
		// div.style.display = "flex"

		// question_container.appendChild(div)

		// plans changed, I want it to be table row now
		var table_body = document.getElementById("tbody")

		var table_row = document.createElement("tr")

		var table_data = document.createElement("td")

		// // so after appending you gotta getElement in order to append to it
		// var div_container = document.getElementById(`div${i}`)

		// append question
		// var question = document.createElement("pre")
		// question.innerHTML = body[i].question

		table_data.textContent = body[i].question
		table_row.appendChild(table_data)


		// let's add a button to go to default page
		var attempt_button = document.createElement("button")
		attempt_button.textContent = "Attempt"
		attempt_button.type = "button"

		// let's add eventlistener to the button and to send parameters
		attempt_button.addEventListener("click", onQuestionClicked.bind(null, body[i].question), false)

		table_data = document.createElement("td")

		table_data.appendChild(attempt_button)

		// table_data.appendChild(go_button)

		// line break
		// var line_break = document.createElement("br")
		// question_container.appendChild(line_break)

		table_row.appendChild(table_data)
		table_body.appendChild(table_row)

		}

	}

	catch (err) {
		console.error(err.message)
	}

}


async function onQuestionClicked(question) {
	// let's try posting HTTP clicked question info and get HTTP it in default/coding html page

	console.log("geh", question)

	var body = {"question": question}


	try {

	// important note to take away here, so you see, the method POST tries to get response back, if no response is given, it gonna try again and again and does not exit this line

	var post_question = await fetch("http://localhost:9002/question_selected", {

		method: "POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify(body)

	})


	}

	catch (err) {
		console.error(err.message)
	}

	finally {
		// well location.href logs the subdomanins you gotta end up in endless back button press, so replace will bring back to home page(chrome search page I think)
		window.location.href = "./default.html"
	}


}