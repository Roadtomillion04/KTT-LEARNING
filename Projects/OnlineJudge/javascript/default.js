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

const url = 'https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=true&wait=false&fields=*';
const options = {
	method: 'POST',
	headers: {
		'x-rapidapi-key': 'b4fd2daefdmshe4c3ed3d7eb1a94p118e15jsn0fd2c20d532e',
		'x-rapidapi-host': 'judge0-ce.p.rapidapi.com',
		'Content-Type': 'application/json'
	},
	body: {
		language_id: 71,
		source_code: 'print("hi")',
		stdin: '1'
	}
};

try {
	const response = await fetch(url, options);
	const result = await response.text();
	console.log(result);
} catch (error) {
	console.error(error);
}		