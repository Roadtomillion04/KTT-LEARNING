test_case_count = 0

// pending bug, add parameter slot multiple when test click is add more

function createTestCaseFields() {

	//every time this function called increase count by 1 to keep track
	test_case_count += 1

	var test_case_parent = document.getElementById("test_cases")

	// lets container the test case slots
	var container = document.createElement("div")
	container.id = `individual_slot${test_case_count}`
	container.className = "test_case_slot"


	// input field
	var input_add = document.createElement("input")
	input_add.type = "number"
	input_add.value = 1 // default 1
	input_add.min = 1
	input_add.max = 5	
	input_add.id = `parameter_count${test_case_count}`

	var confirm_add = document.createElement("button")
	confirm_add.type = "button"
	confirm_add.innerHTML = "add"
	confirm_add.id = `add_button${test_case_count}`
	confirm_add.className = "add_button"


	// now that new textarea element is created, to add it to html page we need to append to parent
	test_case_parent.appendChild(container)

	// you can just directly append to created element here
	container = document.getElementById(`individual_slot${test_case_count}`)

	// now inside container let's add the elements
	container.appendChild(input_add)
	container.appendChild(confirm_add)

	line_break = document.createElement("br")
	line_break.id = `break${test_case_count}`

	container.appendChild(line_break)

	// I am creating and appending Delete button in after add parameter slot for neat visuals and more flexible
	// creating and apending at last
	// delete button add
	var delete_button = document.createElement("button")
	delete_button.id = `delete${test_case_count}`
	delete_button.className = "delete"
	delete_button.innerHTML = "delete"
	container.appendChild(delete_button)
		


	addDeleteEvent()
	addParameterSlots()
}


function addDeleteEvent() {
	var delete_button_batched = document.getElementsByClassName("delete")

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
		var curr_container = document.getElementById(`individual_slot${getNumberFromString(this.id)}`) // this.id is delete id, in this case we have only one element not mutliple

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

async function submitQuestion() {
	var question = document.getElementById('question').value

	var problem_statement = document.getElementById('problem_statement').value

	// getting the parameters and values
	var parameters_batched = document.getElementsByClassName("parameters")
	var inputs_batched = document.getElementsByClassName("values")

	// also parameter count to batch the test cases in order
	var parameter_count = document.getElementById("parameter_count1").value

	// posting test cases in array
	param_arr = []
	value_arr = []

	// both are same length anyway
	for (var i = 0; i < parameters_batched.length; i++) {

		// no problem with parameters
		param_arr.push(parameters_batched[i].value)


		// all values gonna be string, so for array conversion
		if (inputs_batched[i].value[0].includes("[") && inputs_batched[i].value.at(-1).includes("]")) {

			// remove the brackets and at for negative indexing
			inputs_batched[i].value = inputs_batched[i].value.replace("[", "")
			inputs_batched[i].value = inputs_batched[i].value.replace("]", "")

			// presuming array values are spaced after commas
			var new_arr = inputs_batched[i].value.split(", ")

			value_arr.push(new_arr)

		}

		else {
			value_arr.push(inputs_batched[i].value)
		}
		
		}

	try {
		var body = {"question": question, 
		"problem_statement": problem_statement, 
		"test_case_inputs": param_arr,
		"test_case_values": value_arr,
		"step": Number(parameter_count) + 1} // Output last

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

function addParameterSlots() {

	var confirm_button_batched = document.getElementsByClassName("add_button")

	for (var i = 0; i < confirm_button_batched.length; i++) {
	confirm_button_batched[i].addEventListener('click', addSlots, false)

	}

	function addSlots() {

		// cannot append under input element, has to be div/container
		var parent = document.getElementById(`individual_slot${getNumberFromString(this.id)}`)
		var parameter_count = document.getElementById(`parameter_count${getNumberFromString(parent.id)}`).value // in this count this.id gives button id which is test_case_count same for all

		// disabling button after click to avoid bugs
		var curr_button = document.getElementById(`add_button${getNumberFromString(parent.id)}`)
		curr_button.disabled = true

		// +1 for output 
		for (var i = 0; i < Number(parameter_count) + 1; i++) {

			console.log('bonk=jour')

			// creating parameter elements
			var param_input = document.createElement("input")
			var value_input = document.createElement("input")
			line_break = document.createElement("br")

			// setting attributes
			param_input.className = "parameters"
			param_input.placeholder = "parameter name"
			param_input.required = true

			value_input.className = "values"
			value_input.placeholder = "value"
			value_input.required = true

			// well required here is useless anyyway as it's not under the form

			// for output (last slot)
			if (i == parameter_count) {
				param_input.value = "Output"
				param_input.placeholder = ""
				value_input.placeholder = "value"
			}

			parent.appendChild(param_input)
			parent.appendChild(value_input)
			parent.appendChild(line_break)


		}

	}

}
