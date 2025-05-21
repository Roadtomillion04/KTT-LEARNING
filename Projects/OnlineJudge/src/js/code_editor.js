// used lot of sessionStorage as I'm reloading page for every question and also one note if you JSON.stringify, you need to use JSON.parse to get it to object, or it's pushed to db as string

document.addEventListener("DOMContentLoaded", initialize, false)

async function initialize() {

	await tokenVerification() // await is yield

	await selectNQuestions()

	// idk this works, on reload, first time load as intented so yeah
	// fetchQuestion()

	displayQuestion()


	// going full screen when click on image
	document.getElementById("fullscreen_img").addEventListener("click", resizeScreen, false)

	
	// it's basically a physics process with ms to control calling
	setInterval(displayTimeRemaining, 1000) // 1000ms is 1 sec


}

async function tokenVerification() {
	var token_verify = await fetch("http://localhost:8999/check_user", {

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


async function selectNQuestions() {

	try {

	var get_five_questions = await fetch(`http://localhost:8999/test_questions/${sessionStorage.getItem("no_of_questions")}`, {

		method: "GET",
		headers: {"Content-Type": "application/json"}
	})

	var body 

	if (sessionStorage.getItem("questions_selected") == null) {
	
		body = await get_five_questions.json()

		sessionStorage.setItem("questions_selected", JSON.stringify(body))
		
	}

	else {

		body = JSON.parse(sessionStorage.getItem("questions_selected"))
		}

	}

	catch (err) {
		console.error(err.message)
	}

	// let's try creating buttons here as it calls only once in the script, no on next refresh the button are gone 

	var question_count = sessionStorage.getItem("no_of_questions")

	for (var i = 1; i <= Number(question_count); i++) {

		var new_button = document.createElement("button")

		new_button.className = "qbtn"
		new_button.textContent = "Question #" + i

		document.getElementById("qbtn_container").appendChild(new_button)
	}


	// so assign question to the buttons
	var batched_question_button = document.getElementsByClassName("qbtn") // is array

	// let's add click event
	for (var i = 0; i < batched_question_button.length; i++) {

		batched_question_button[i].addEventListener("click", setQuestion.bind(null, body[i].question), null)

	}

	// var select_option = document.getElementById("select_option")

	// select_option.addEventListener("change", displaySelectedQuestion.bind(null, body), null)

}

function setQuestion(question) {

	sessionStorage.setItem("question", question)

	location.reload() // mainly for judge0 ide, to refresh for each question

}

async function displayQuestion() {

	var question = ""

	// on page load, no button clicked sessionStorage shall be null, when it is

	if (sessionStorage.getItem("question") == null) {

		question = JSON.parse(sessionStorage.getItem("questions_selected"))[0].question

	}

	else {
		question = sessionStorage.getItem("question")
	}


	// this no working, so get the select again and get the value
	// var selected_question = document.getElementById("select_option").value

	// var question = body[selected_question].question


	console.log(question)

	var body = {"question": question}


	try {

	// important note to take away here, so you see, the method POST/GET tries to get response back, if no response is given, it gonna try again and again and does not exit this line

	var post_question = await fetch("http://localhost:8999/post_question_clicked_on_test_page", {

		method: "POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify(body)

	})

	// returns json inside an array
	var res = await post_question.json()

	console.log(res)


	await addQuestionToPage(res[0])

	// also sending body to judge 0 for input and output
	await judge0(res[0])


	}

	catch (err) {
		console.error(err.message)
	}

	finally {
		// fetchQuestion()

		// location.reload()
	}


}

async function fetchQuestion() {

	try {
		var questions = await fetch("http://localhost:8999/get_question_to_display_on_default_page", 
		{
			method: "GET",
			headers: {"Content-Type": "application/json"}
		})

		// returns json inside an array
		var res = await questions.json()

		console.log(res)

		// in awhile let's update question name in header
		document.getElementById("header_question").textContent = res[0].question

		// document.getElementById("select_option").options[0].textContent = res[0].question

		await addQuestionToPage(res[0])

		// also sending body to judge 0 for input and output
		judge0(res[0])
	}

	catch (err) {
		console.error(err.message)
	}

}


function addQuestionToPage(body) {

	// first let's get the containers
	var question_container = document.getElementById("question")

	var problem_statement_container = document.getElementById("problem_statement")


	// adding question
	var question = document.createElement("pre")
	question.innerHTML = body.question
	question.style.fontSize = "1rem"

	question_container.appendChild(question)

	//adding problem Statement
	var problem_statement = document.createElement("pre")
	problem_statement.innerHTML = body.problem_statement
	problem_statement.style.fontSize = "1rem"

	problem_statement_container.appendChild(problem_statement)


	// adding examples
	var example_parent = document.getElementById("examples")

	for (var [example_num, example_obj] of Object.entries(body.examples)) {

		// for css purpose only, creating new div everytime
		var example_container = document.createElement("div")
		example_container.className = "examples"

		var input_output_container = document.createElement("div")
		input_output_container.className = "input_output_div"
			
		// well let's add br here, it look conjested on html
		var line_break = document.createElement("br")
		example_container.appendChild(line_break)

		// now key shall be header
		var example_number = document.createElement("h3")
		example_number.innerHTML = example_num

		example_container.appendChild(example_number)

		example_container.appendChild(input_output_container)

		// unpack (nested object)
		for (var [key, value] of Object.entries(example_obj)) {

			var new_pair = document.createElement("pre")

			// this is for visual purpose only, nothing else
			if (key != "Explanation") {
				new_pair.innerHTML = key + "<br>" + "<hr>" + value
				new_pair.style.fontSize = "1rem"
			}

			else {
				new_pair.innerHTML = key + "<br>" + value
				new_pair.style.fontSize = "1rem"
			}

			// and also for the cases only one explanation is given, and next one not given, filter

			if (key == "Explanation" && value == undefined) {
			
				new_pair.innerHTML = ""

			} 

			// well let's add br here, it look conjested on html
			line_break = document.createElement("br")
			input_output_container.appendChild(	line_break)

			// css purposes, display flex only Input and Output so yeah

			if (key == "Explanation") {
				example_container.appendChild(new_pair)
			}

			else {
			input_output_container.appendChild(new_pair)
			}
		}

		example_parent.appendChild(example_container)
		line_break = document.createElement("br")
			example_parent.appendChild(line_break)


	}
	
}

// now that the refactoring is complete, next step is to give the example input value to input and other test cases inputs(hidden)

function judge0(question_body) {

	let iframeDataViewer = document.getElementById("judge0-ide-data-viewer");

    let judge0IDE = document.getElementById("judge0-ide");

    window.onmessage = function(e) {
        if (!e.data) {
            return;
        }

        iframeDataViewer.innerHTML = JSON.stringify(e.data, null, 2);

        // so the initial objective is to for all test cases we looping, we giving 1 test case only to for user to run and check, rest of them will be evaluated with the code they write

        if (e.data.event === "initialised") {
            // Make sure to only post data after the IDE is initialised
            // When setting the data, make sure to set the action to "set".
            //
            // The data you send will be used to populate the IDE.
            // You don't have to send all the data, only the data you want to set.
            //
            // Make sure to get your API key at https://platform.sulu.sh/apis/judge0
            // If you don't set your API key, the default API key will be used, which has limitations and should not be used in production.
            judge0IDE.contentWindow.postMessage({
                action: "set",
                api_key: "",
                source_code: "#",
                language_id: 71,
                flavor: "CE",
                stdin: `${question_body.test_cases.test_case1.Input}`,
                stdout: null,
                compiler_options: "",
                command_line_arguments: "",
            }, '*');
        }

        // so we getting user code here to compare to rest of the test cases (done in hidden)
        if (e.data.event === "preExecution") {
        	var user_code = e.data.source_code

        	var language_id = e.data.language_id

        	// set user_code, useful to check after submission
        	sessionStorage.setItem("user_code", user_code)

        	// set language, also pushing this to db, we have only id here, let's request for language name

        	fetchLanguage(language_id)
        
        }


        if (e.data.event === "postExecution") {
        	var output = e.data.output

        	var output_text = document.getElementById("judge0_evaluation")

        	output_text.textContent = "Output: " + output + "\n" + "Expected Output: " + question_body.test_cases.test_case1.Output

        	if (output == question_body.test_cases.test_case1.Output) {


        	 	sessionStorage.setItem(`${question_body.question} status`, JSON.stringify({"given_input": question_body.test_cases.test_case1.Input, "expected_output": question_body.test_cases.test_case1.Output,
        	 		"user_ouput": output, "source_code": sessionStorage.getItem("user_code"), "is_passed": true, "used_language": sessionStorage.getItem("language_name")}))
        	 }

   		}

    };

}



async function fetchLanguage(language_id) {

	var get_langauge_name = await fetch(`https://ce.judge0.com/languages/${language_id}`, {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	var language_name = await get_langauge_name.json()

	var lang = language_name.name

	sessionStorage.setItem("language_name", lang)

}


// just old trick odd or even
var count = 0

function resizeScreen() {

	count += 1
	
	var question_page_div = document.getElementsByClassName("page_div")[0]

	var code_editor_div = document.getElementsByClassName("code_editor_div")[0]

	if (count % 2 != 0) {

	code_editor_div.style.width = "100vw"

	question_page_div.style.width = "0vw"

	}

	else {

		code_editor_div.style.width = "50vw"

		question_page_div.style.width = "50vw"
	
	}
	
}

async function displayTimeRemaining() {

	var get_curr_time = await fetch("http://localhost:8999/time_remaining", {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	var res = await get_curr_time.json()

	var timer = document.getElementById("timer")

	timer.textContent = "Time Remaining: " + res.hour + " hours" + " " + res.min + " minutes" + " " + res.sec + " seconds"

}


async function submitAnswers() {

	var question_pass_status = {}

	// unpacking the array and inside is questions
	for (obj of JSON.parse(sessionStorage.getItem("questions_selected"))) {

		// so the logic here is stroing each question status individually in sessionStorage and grabing it all here, if sessionStorage question does not exist np it return null by default
		question_pass_status[`${obj.question} status`] = JSON.parse(sessionStorage.getItem(`${obj.question} status`))

	}

	console.log(question_pass_status)

	// relying too much on sessionStorage
	var body = {
		"test_id": sessionStorage.getItem("test_id"),
		"roll_no": sessionStorage.getItem("roll_no"),
		"questions_passed": question_pass_status

	}

	try {

	var post_submission = await fetch("http://localhost:8999/submit_answers", {

		method: "POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify(body)

	})

	}

	catch (err) {
		console.error(err.message)
	}

	finally {
		alert("Test Submitted!")

		// removing everything in session, so they don't have access anymore
		sessionStorage.clear()

		// let's just redirect back to login
		window.location.replace("./login.html")

	}


}