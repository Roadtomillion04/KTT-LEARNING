document.addEventListener("DOMContentLoaded", initialize, false)

async function initialize() {

	// await tokenVerification() // await is yield
	fetchQuestion()


	// going full screen when click on image
	document.getElementById("fullscreen_img").addEventListener("click", resizeScreen, false)

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


async function run() {

	var code = document.getElementById("src_code").value


	var language = 71

	var body = {

		"source_code": code,
		"language_id": language,
		"number_of_runs": null,
		"stdin": null,
		"expected_output": 2,
		"cpu_time_limit": null,
		"memory_limit": null,
		"max_processes_and_or_threads": null,
		"enable_per_process_and_thread_time_limit": null,
		"enable_per_process_and_thread_memory_limit": null,
		"max_file_size": null,
		"enable_network": null

	}


	var get_res = await fetch("http://localhost:2358/submissions/", {

		method: "POST",
		headers: {"content-type": "application/json"},
		referrer: "http://localhost:2358/dummy-client.html",
  		body: JSON.stringify(body)
	})

	var res = await get_res.json()

	// so now that it is working, it returns the token

	verifyResult(res.token)

}

async function verifyResult(token) {

	var results = await fetch(`http://localhost:2358/submissions/${token}`, {

		method: "GET",
		headers: {"content-type": "application/json"}

	})

	var body = await results.json()

	console.log(body)

	// await verifyResult(token)

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

        	sessionStorage.setItem("user_code", user_code)

        }


        if (e.data.event === "postExecution") {
        	var output = e.data.output

        	var output_text = document.getElementById("judge0_evaluation")

        	output_text.textContent = "Output: " + output + "\n" + "Expected Output: " + question_body.test_cases.test_case1.Output

        	// if (output == question_body.test_cases.test_case1.Output) {
        	// 	sessionStorage.setItem("passed", true)
        	// }

    		console.log(output)

   		}

    };

}

async function submitAnswer() {

	var question = {}

	sessionStorage.setItem("answer_submission", JSON.stringify({"hi": "ok"}))

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


