test_case_count = 0

function createTestCaseFields() {

	//every time this function called increase count by 1 to keep track
	test_case_count += 1

	var test_case_parent = document.getElementById("test_cases")

	// text area add
	var input_add = document.createElement("input")
	input_add.type = "number"
	input_add.value = 1 // default 1
	input_add.min = 1
	input_add.max = 5	
	input_add.id = "parameter_count"

	var confirm_add = document.createElement("button")
	confirm_add.type = "button"
	confirm_add.innerHTML = "confirm"
	confirm_add.id = "clicked"

	// delete button add
	// var delete_button = document.createElement("button")
	// delete_button.id = `delete${test_case_count}`
	// delete_button.className = "delete"
	// delete_button.innerHTML = "delete"

	// now that new textarea element is created, to add it to html page we need to append to parent
	test_case_parent.appendChild(input_add)
	// test_case_parent.appendChild(delete_button)
	test_case_parent.appendChild(confirm_add)

	line_break = document.createElement("br")
	line_break.id = `break${test_case_count}`

	test_case_parent.appendChild(line_break)

	updateElement()
	add_parameter_slots()
}


function updateElement() {
	var class_delete = document.getElementsByClassName("delete")

	console.log(class_delete)

	// assign event listener everytime (refreshes index when element get deleted)
	for (var i = 0; i < class_delete.length; i++) {
	class_delete[i].addEventListener('click', deleteElement, false)
	}

	function deleteElement() {
		console.log("deltedId", this.id)

		// parseInt not work alpha before digits
		// console.log(parseInt(this.id))
		// console.log(parseInt("aaaa23"))
		// console.log(typeof this.id)

		console.log(getNumberFromString(this.id))

		document.getElementById(`textarea${getNumberFromString(this.id)}`).remove()
		document.getElementById(`delete${getNumberFromString(this.id)}`).remove()

		// removing br element will resolve space in between issues
		document.getElementById(`break${getNumberFromString(this.id)}`).remove()


		console.log(class_delete)

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

async function submitQuestion() {
	var question = document.getElementById('question').value

	var problem_statement = document.getElementById('problem_statement').value

	var all_test_cases = document.getElementsByClassName('test_case')

	// split input and output
	var input = ""
	var output = ""

	// posting test cases in array
	var input_arr = []
	var output_arr = []

	for (var i = 0; i < all_test_cases.length; i++) {

		// getting input parameters and output in two strings by line break
		[input, output] = all_test_cases[i].value.split("\n")

		input_arr.push(input.slice(7))
		output_arr.push(output.slice(8))
		
		}

	try {
		var body = {"question": question, 
		"problem_statement": problem_statement, 
		"test_case_input": input_arr,
		"test_case_output": output_arr}

		var req = await fetch("http://localhost:9001/add_question", {
			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})

	}

	catch (err) {
		console.log(err.message)
	}
}

function add_parameter_slots() {

	var confirm_button = document.getElementById("clicked")

	confirm_button.addEventListener('click', updateField, false)

	function updateField() {

		// cannot append under input element, has to be div/container
		var parent = document.getElementById("please_work")
		var parameter_count = document.getElementById("parameter_count").value

		// +1 for output 
		for (var i = 0; i < Number(parameter_count) + 1; i++) {

			console.log('bonk=jour')

			// creating parameter elements
			var param_input = document.createElement("input")
			var value_input = document.createElement("input")
			line_break = document.createElement("br")

			// setting attributes
			param_input.placeholder = "parameter name"
			value_input.placeholder = "value"

			// for output (last slot)
			if (i == parameter_count) {
				param_input.value = "Output"
				value_input.placeholder = "value"
			}

			parent.appendChild(param_input)
			parent.appendChild(value_input)
			parent.appendChild(line_break)

		}

	}

}
