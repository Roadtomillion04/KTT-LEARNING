// is same as create question page, on page load we fetching question data and adding values to the fields

document.addEventListener("DOMContentLoaded", adminVerification, false)

async function adminVerification() {

		var is_admin = sessionStorage.getItem("is_admin")

		if (is_admin != "yes") {
			alert("not authorized")

			// redirect
			window.location.replace("./login.html")
	}
}


document.addEventListener("DOMContentLoaded", getQuestionToEdit, false)

// parameter for PUT
var question_id = null

async function getQuestionToEdit() {

	var get_question = await fetch("http://localhost:9005/get_question_to_edit", {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	// gets question from db 
	body = await get_question.json()

	question_id = body.question_id

	await unpackAndInsertFields(body) // await is yield
}

// let's unpack here
async function unpackAndInsertFields(body) {

	var question_field = document.getElementById("question")

	question_field.textContent = body.question

	var problem_statement_field = document.getElementById("problem_statement")

	problem_statement_field.textContent = body.problem_statement

	console.log(body.test_cases)


	// first, test cases
	// this i is for accessing next index of the batched param/values array returned by className
	var i = 0

	var inputs = document.getElementsByClassName("test_case_input")

	var outputs = document.getElementsByClassName("test_case_output")

	for ([test_case_title, test_case_obj] of Object.entries(body.test_cases)) {

		
		createTestCaseFields()

		// Input value coming first, then output
		for ([key, value] of Object.entries(test_case_obj)) {

			console.log(key)

			// so, the unpack order is [ip, op, ip, op...]

			if (key == "Input") {
				inputs[i].textContent = value
			}

			else {
			outputs[i].textContent = value
			}

		}

		i += 1

	}

	// now example
	// this j is for accessing next index of the batched textarea array returned by className
	var j = 0

	var example_inputs = document.getElementsByClassName("example_input")

	var example_outputs = document.getElementsByClassName("example_output")

	var example_explanations = document.getElementsByClassName("example_explanation")

	for ([example_title, example_obj] of Object.entries(body.examples)) {

		createExampleFields()

		for ([key, value] of Object.entries(example_obj)) {

			// so on unpacking all of the examples 

			if (key == "Input") {
				example_inputs[j].textContent = value
			}

			else if (key == "Output") {
				example_outputs[j].textContent = value
			}

			else {
				example_explanations[j].textContent = value
			}

		}

		j += 1

	}

}

document.addEventListener("DOMContentLoaded", adminVerification, false)

async function adminVerification() {

		var is_admin = sessionStorage.getItem("is_admin")

		if (is_admin != "yes") {
			alert("not authorized")

			// redirect
			window.location.replace("./login.html")
	}
}


test_case_count = 0

async function createTestCaseFields() {

	test_case_count += 1

	var test_case_parent = document.getElementById("test_cases")

	var container = document.createElement("div")
	container.id = `test_case_field${test_case_count}`

	// text area add for input
	var input_text_area = document.createElement("textarea")
	input_text_area.id = `input${test_case_count}`
	input_text_area.className = 'test_case_input' // for css and retrieving
	input_text_area.placeholder = "Input"

	// text area add for output 
	var output_text_area = document.createElement("textarea")
	output_text_area.id = `output${test_case_count}`
	output_text_area.className = 'test_case_output'
	output_text_area.placeholder = "Output"

	var delete_button = document.createElement("button")
	delete_button.id = `delete_test_case${test_case_count}`
	delete_button.className = "delete_test_case"
	delete_button.innerHTML = "delete"

	line_break = document.createElement("br")
	container.appendChild(line_break)

	test_case_parent.appendChild(container)

	container.appendChild(input_text_area)
	container.appendChild(output_text_area)

	line_break = document.createElement("br")
	container.appendChild(line_break)

	container.appendChild(delete_button)

	addDeleteEvent(delete_button.className, "test_case_field")
		
}


// let's reuse the same function for test case and examples by adding parameter
function addDeleteEvent(class_name, container_name) {
	var delete_button_batched = document.getElementsByClassName(class_name)

	console.log(delete_button_batched)

	// assign event listener everytime (refreshes index when element get deleted)
	for (var i = 0; i < delete_button_batched.length; i++) {
	delete_button_batched[i].addEventListener('click', deleteElement, false)
	}

	function deleteElement() {
		// this is a delete button that is clicked	
		console.log("deltedId", this.id)

		// parseInt not work alpha before digits
		// console.log(parseInt(this.id))
		// console.log(parseInt("aaaa23"))
		// console.log(typeof this.id)

		console.log(getNumberFromString(this.id))

		// lets just delete the container
		var curr_container = document.getElementById(container_name + getNumberFromString(this.id)) // this.id is delete id, in this case we have only one element not mutliple

		curr_container.remove()


		console.log(delete_button_batched)

	}
}

function getNumberFromString(str) {
	var num = 0

	for (var i = 0; i < str.length; i++) {
		if (isNaN(Number(str[i])) == false) {
			num = (num * 10) + Number(str[i])
		}
	}

	return num

}

async function submitEditedQuestion() {
	var question = document.getElementById('question').value

	var problem_statement = document.getElementById('problem_statement').value

	var test_case_inputs = document.getElementsByClassName("test_case_input")

	var test_case_outputs = document.getElementsByClassName("test_case_output")


	var test_cases = {}

	for (var i = 0; i < test_case_inputs.length; i++) {

		test_cases[`test_case${i+1}`] = {"Input": test_case_inputs[i].value, "Output": test_case_outputs[i].value}

	}

	console.log(test_cases)
 

	// examples here
	var example_inputs = document.getElementsByClassName("example_input")

	var example_outputs = document.getElementsByClassName("example_output")

	var example_explanations = document.getElementsByClassName("example_explanation")


	var examples = {}

	for (var i = 0; i < example_inputs.length; i++) {

		examples[`Example${i+1}`] = {
			"Input": example_inputs[i].value,
			"Output": example_outputs[i].value,
			"Explanation": example_explanations[i].value
		}

	}

	console.log(examples)

	try {
		var body = {"question": question, 
		"problem_statement": problem_statement,
		"test_cases": test_cases,
		"examples": examples
		} 

		var req = await fetch(`http://localhost:9005/update_question/${question_id}`, {
			method: "PUT",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})

	}

	catch (err) {
		console.log(err.message)
	}

	finally {

		//switching to welcome page for update
		window.location.replace("./welcome_page.html")

	}
}


var example_field_count = 0

function createExampleFields() {

	example_field_count += 1

	var example_field_parent = document.getElementById("examples")


	var container = document.createElement("div")
	container.id = `example_field${example_field_count}`

	// text area add for input
	var input_text_area = document.createElement("textarea")
	input_text_area.id = `example_input${test_case_count}`
	input_text_area.className = 'example_input'
	input_text_area.placeholder = "Input"

	// text area add for output 
	var output_text_area = document.createElement("textarea")
	output_text_area.id = `example_output${test_case_count}`
	output_text_area.className = 'example_output'
	output_text_area.placeholder = "Output"


	// explanation text area add
	var explanation_text_area = document.createElement("textarea")
	explanation_text_area.id = `explanation${example_field_count}`
	explanation_text_area.className = 'example_explanation'
	explanation_text_area.placeholder = "Explanation"


	// delete button add for examples, should be renamed class name to avoid collision
	var delete_button = document.createElement("button")
	delete_button.id = `delete_example${example_field_count}`
	delete_button.className = "delete_examples"
	delete_button.innerHTML = "delete"

	line_break = document.createElement("br")
	container.appendChild(line_break)

	example_field_parent.appendChild(container)

	container.appendChild(input_text_area)
	container.appendChild(output_text_area)

	line_break = document.createElement("br")
	container.appendChild(line_break)

	container.appendChild(explanation_text_area)

	line_break = document.createElement("br")
	container.appendChild(line_break)


	container.appendChild(delete_button)


	addDeleteEvent(delete_button.className, "example_field")

}
