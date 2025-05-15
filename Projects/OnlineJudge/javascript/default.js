// async function runProgram() {

// 	// get text area value
// 	// var code = document.getElementById("src-code").value

// 	// var judge_api_url = await fetch("http://localhost:2358/dummy-client.html")

// 	// var a = await judge_api_url.text()

// 	// console.log(a)

// 	const url = 'https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=true&wait=false&fields=*';
// 	const options = {
// 	method: 'POST',
// 	headers: {
// 		'x-rapidapi-key': 'b4fd2daefdmshe4c3ed3d7eb1a94p118e15jsn0fd2c20d532e',
// 		'x-rapidapi-host': 'judge0-ce.p.rapidapi.com',
// 		'Content-Type': 'application/json'
// 	},
// 	body: {
// 		language_id: 71,
// 		source_code: 'print("hi")',
// 		stdin: '5 2'
// 	}
// };

	
// 	const response = await fetch(url, options);
// 	const result = await response.text();
// 	console.log(result);
	
// }

// runProgram()

// const url = 'https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=true&wait=false&fields=*';
// const options = {
// 	method: 'POST',
// 	headers: {
// 		'x-rapidapi-key': 'b4fd2daefdmshe4c3ed3d7eb1a94p118e15jsn0fd2c20d532e',
// 		'x-rapidapi-host': 'judge0-ce.p.rapidapi.com',
// 		'Content-Type': 'application/json'
// 	},
// 	body: {
// 		language_id: 71,
// 		source_code: 'print("hi")',
// 		stdin: '1'
// 	}
// };

// try {
// 	const response = await fetch(url, options);
// 	const result = await response.text();
// 	console.log(result);
// } catch (error) {
// 	console.error(error);
// }

console.log("hi")

document.addEventListener("DOMContentLoaded", initialize, false)

async function initialize() {

	// await tokenVerification() // await is yield
	// fetchQuestion()
	judge0()
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

async function fetchQuestion() {

	try {
		var questions = await fetch("http://localhost:9005/get_question_to_display_on_default_page", 
		{
			method: "GET",
			headers: {"Content-Type": "application/json"}
		})

		// returns json inside an array
		var res = await questions.json()

		console.log(res)

		addQuestionToPage(res[0])
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
		example_container.className = "example"
			
		// well let's add br here, it look conjested on html
		var line_break = document.createElement("br")
		example_container.appendChild(line_break)

		// now key shall be header
		var example_number = document.createElement("h3")
		example_number.innerHTML = example_num

		example_container.appendChild(example_number)

		// unpack (nested object)
		for (var [key, value] of Object.entries(example_obj)) {
			var new_pair = document.createElement("pre")

			// key is not needed as value itself contains I/p, O/p and Explanation
			new_pair.innerHTML = value
			new_pair.style.fontSize = "1rem"

			// and also for the cases only one explanation is given, and next one not given, filter

			if (key == "Explanation" && value == undefined) {
			
				new_pair.innerHTML = ""

			} 

			// well let's add br here, it look conjested on html
			line_break = document.createElement("br")
			example_container.appendChild(line_break)

			example_container.appendChild(new_pair)
		}

		example_parent.appendChild(example_container)
		line_break = document.createElement("br")
			example_parent.appendChild(line_break)


	}
	
}


// now
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

function judge0() {

	let iframeDataViewer = document.getElementById("judge0-ide-data-viewer");

    let judge0IDE = document.getElementById("judge0-ide");

    window.onmessage = function(e) {
        if (!e.data) {
            return;
        }

        iframeDataViewer.innerHTML = JSON.stringify(e.data, null, 2);

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
                source_code: "...",
                language_id: 71,
                flavor: "CE",
                stdin: `3\n${JSON.parse("[1, 2, 3]")}`,
                stdout: null,
                compiler_options: "",
                command_line_arguments: "",
            }, '*');
        }


        if (e.data.event === "postExecution") {


    		console.log(e.data.output)

    	}

    };
   
}

async function submitAnswer() {

	var body = {
		"test_id": 1,
		"roll_no": "7376212AL135",
		"question_id": 1,
		"test_case_results": {"test_case1": {"Input": }}
	}

}

