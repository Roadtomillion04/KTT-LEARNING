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

document.addEventListener("DOMContentLoaded", fetchQuestion)

async function fetchQuestion() {

	try {
		var questions = await fetch("http://localhost:9002/get_question", 
		{
			method: "GET",
			headers: {"Content-Type": "application/json"}
		})

		// returns json inside an array
		var res = await questions.json()

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

	var example_container = document.getElementById("examples")

	// adding question
	var question = document.createElement("pre")
	question.innerHTML = body.question

	question_container.appendChild(question)

	//adding problem Statement
	var problem_statement = document.createElement("pre")
	problem_statement.innerHTML = body.problem_statement

	problem_statement_container.appendChild(problem_statement)

	// adding examples
	for (var [example_num, example_obj] of Object.entries(body.examples)) {
		
		// now key shall be header
		var example_number = document.createElement("h3")
		example_number.innerHTML = example_num

		example_container.appendChild(example_number)

		// unpack (nested object)
		for (var [key, value] of Object.entries(example_obj)) {
			var new_pair = document.createElement("pre")

			// key is not needed as value itself contains I/p, O/p and Explanation
			new_pair.innerHTML = value

			// and also for the cases only one explanation is given, and next one not given, filter

			if (key == "Explanation" && value == undefined) {
			
				new_pair.innerHTML = ""

			} 

			example_container.appendChild(new_pair)
		}

	}

	

	
}


