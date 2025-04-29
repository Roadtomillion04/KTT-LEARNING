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
		var questions = await fetch("http://localhost:9001/get_questions", 
		{
			method: "GET",
			headers: {"Content-Type": "application/json"}
		})

		// returns json inside an array
		var res = await questions.json()

		// random return float only, so floor or ceil
		console.log(Math.floor(Math.random(res.length)))

		// for now let's send one question
		addQuestionToPage(res[1])
	}

	catch (err) {
		console.error(err.message)
	}
}


function addQuestionToPage(question_body) {

	// first let's get the containers
	var question_container = document.getElementById("question")

	var problem_statement_container = document.getElementById("problem_statement")

	var example1_container = document.getElementById("Example 1")

	var example2_container = document.getElementById("Example 2")

	// adding question
	var question = document.createElement("p")
	question.innerHTML = question_body.question

	question_container.appendChild(question)

	//adding problem Statement
	var problem_statement = document.createElement("p")
	problem_statement.innerHTML = question_body.problem_statement

	problem_statement_container.appendChild(problem_statement)

	// add example 1 - let's keep it to two examples for now
	var example1 = document.createElement("code")

	console.log(question_body.test_cases.test_case1.nums)

	// destructing with obj.entries
	
	for (var [key, value] of Object.entries(question_body.test_cases.test_case1)) {

		example1.innerHTML += " " + `${key} = ${value}`

	}

	example1_container.appendChild(example1)


	var example2 = document.createElement("code")

	// destructing with obj.entries
	
	for (var [key, value] of Object.entries(question_body.test_cases.test_case2)) {

		example2.innerHTML += " " + `${key} = ${value}`

	}

	example2_container.appendChild(example2)
}


