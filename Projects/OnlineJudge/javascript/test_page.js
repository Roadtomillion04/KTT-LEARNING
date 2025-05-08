document.addEventListener("DOMContentLoaded", initialize, false)

// so before loading question, we are checking jwt token exists from login page
async function initialize() {
	await tokenVerification() // await here is like yield
	selectFiveQuestions()
}


async function tokenVerification() {
	
	var token_verify = await fetch("http://localhost:9005/check_user", {

		// okay so don't be confused with the GET method here, we are sending sessionStorage in headers, it'll recive in express
		method: "GET",
		headers: {"Content-Type": "application/json", "user_token": sessionStorage.getItem("user_token")}

	})

	var res = await token_verify.json()

	console.log(res)

	if (res.user == "invalid") {
		alert("not authorized")

		// redirect
		window.location.replace("./login.html")
	}

}


async function selectFiveQuestions() {

	try {

	var get_five_questions = await fetch("http://localhost:9005/test_questions", {

		method: "GET",
		headers: {"Content-Type": "application/json"}
	})

	var body 

	if (sessionStorage.getItem("questions_selected") == null) {
	
		body = await get_five_questions.json()


		sessionStorage.setItem("questions_selected", JSON.stringify(body))

	}

	else {

		console.log(JSON.parse(sessionStorage.getItem("questions_selected")))

		body = JSON.parse(sessionStorage.getItem("questions_selected"))
	}



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

		// var table_row = document.createElement("tr")

		// var table_data = document.createElement("td")

		// insertRow and insertCell seem more convinient
		var row = table_body.insertRow(i)

		var cell1 = row.insertCell(0)
		var cell2 = row.insertCell(1)
		var cell3 = row.insertCell(2)

		// // so after appending you gotta getElement in order to append to it
		// var div_container = document.getElementById(`div${i}`)

		// append question
		// var question = document.createElement("pre")
		// question.innerHTML = body[i].question

		// table_data.textContent = body[i].question
		// table_row.appendChild(table_data)

		cell1.textContent = body[i].question

		// let's add a button to attempt questionn
		var attempt_button = document.createElement("button")
		attempt_button.textContent = "Attempt"
		attempt_button.type = "button"

		// let's add eventlistener to the button and to send parameters
		attempt_button.addEventListener("click", onQuestionClicked.bind(null, body[i].question), false)

		// table_data = document.createElement("td")

		// table_data.appendChild(attempt_button)

		cell2.appendChild(attempt_button)

		
		// third column will be completion status
		var completion_status = document.createElement("input")

		completion_status.type = "checkbox"

		completion_status.value = "complete"
		
		completion_status.className = ""


		// table_data.appendChild(completion_status)	

		cell3.appendChild(completion_status)

		// table_data.appendChild(go_button)

		// line break
		// var line_break = document.createElement("br")
		// question_container.appendChild(line_break)

		// table_row.appendChild(table_data)
		// table_body.appendChild(table_row)


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

	// important note to take away here, so you see, the method POST/GET tries to get response back, if no response is given, it gonna try again and again and does not exit this line

	var post_question = await fetch("http://localhost:9005/post_question_clicked_on_test_page", {

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