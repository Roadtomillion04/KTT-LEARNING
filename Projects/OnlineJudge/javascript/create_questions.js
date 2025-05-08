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

// leetcode contains array of elements with no spaces and my method of conversion is totally flawed for the nd array


// i used async here because i want to addparameters() to finish executing first and then appendchild delete button so that it's at last 
async function createTestCaseFields() {

	//every time this function called increase count by 1 to keep track
	test_case_count += 1

	var test_case_parent = document.getElementById("test_cases")

	// lets container the test case slots
	var container = document.createElement("div")
	container.id = `individual_slot${test_case_count}`
	container.className = "test_case_slot"


	// input field - dont need this anymore as I am going to add it for one time in html page
	// var input_add = document.createElement("input")
	// input_add.type = "number"
	// input_add.value = 1 // default 1
	// input_add.min = 1
	// input_add.max = 5	
	// input_add.id = `parameter_count${test_case_count}`

	// var confirm_add = document.createElement("button")
	// confirm_add.type = "button"
	// confirm_add.innerHTML = "add"
	// confirm_add.id = `add_button${test_case_count}`
	// confirm_add.className = "add_button"


	// now that new textarea element is created, to add it to html page we need to append to parent
	test_case_parent.appendChild(container)

	// you can just directly append to created element here
	container = document.getElementById(`individual_slot${test_case_count}`)

	// now inside container let's add the elements
	// container.appendChild(input_add)
	// container.appendChild(confirm_add)

	line_break = document.createElement("br")
	line_break.id = `break${test_case_count}`

	container.appendChild(line_break)

	// basically yield
	await addParameterSlots()

	// I am creating and appending Delete button in after add parameter slot for neat visuals and more flexible
	// creating and apending at last
	// delete button add
	var delete_button = document.createElement("button")
	delete_button.id = `delete${test_case_count}`
	delete_button.className = "delete"
	delete_button.innerHTML = "delete"
	container.appendChild(delete_button)

	addDeleteEvent(delete_button.className, "individual_slot")
		
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

async function submitQuestion() {
	var question = document.getElementById('question').value

	var problem_statement = document.getElementById('problem_statement').value

	// getting the parameters and values
	var parameters_batched = document.getElementsByClassName("parameters")
	var inputs_batched = document.getElementsByClassName("values")

	// This is needed to jump between test cases
	var step = Number(document.getElementById("parameter_count").value)

	value_arr = []

	// creating to object to push it as json in database
	test_cases = {}
	
	step = Number(step) + 1 // output
	
	// creating an empty object value to assign test cases
	var test_case_count = 1
	test_cases[`test_case${test_case_count}`] = {}

	// both are same length anyway
	for (var i = 0; i < parameters_batched.length; i++) {

		// all values gonna be string, so for array conversion
		if (inputs_batched[i].value[0].includes("[") && inputs_batched[i].value.at(-1).includes("]")) {

			console.log("look at here")
			console.log(JSON.parse(inputs_batched[i].value))

			// remove the brackets and at for negative indexing
			// inputs_batched[i].value = inputs_batched[i].value.replace("[", "")
			// inputs_batched[i].value = inputs_batched[i].value.replace("]", "")

			// var new_arr = inputs_batched[i].value.split(",")

			// SO MUCH TIME WASTED ON PYTHON FLASK AND NP ARRAY TRYING TO TYPE CAST, WHILE I COULD HAVE JUST USED JSON PARSE(THIS THING EVEN CONVERTS NUMBERS TO NUMBERS)
			var new_arr = JSON.parse(inputs_batched[i].value)

			value_arr.push(new_arr)
		}

		else {
			value_arr.push(inputs_batched[i].value)
		}

		console.log(parameters_batched[i].value)
		console.log(value_arr[i])

		// for whatever reason .notation no works so whenever duplicate occurs gotta store it inside object (nested)

		// as indexing starts from 0, so when i === step which is next starting test case parameter, we create new object value for a updated key
		if (i === step) {
			test_case_count += 1
			test_cases[`test_case${test_case_count}`] = {}
			
			step += step
		}


		// values will be assigned inside the respective test case nested object
		test_cases[`test_case${test_case_count}`][parameters_batched[i].value] =
				value_arr[i]
	
	}

	console.log(test_cases)


	// getting examples and storing it in object same as test cases for more flexibility than array(no know how to push T_T)
	var examples_class = document.getElementsByClassName("example")

	console.log(examples_class)

	var examples = {}
	
	var example_count = 1

	for (example of examples_class) {

		examples[`Example${example_count}`] = {}
		
		// presumming pre determined field won't mess up		
		examples[`Example${example_count}`]["Input"] = example.value.split("\n")[0]

		examples[`Example${example_count}`]["Output"] = example.value.split("\n")[1]

		// if Explanation given after 2nd line(leetcode) this can be any no of line so
		if (example.value.split("\n")[2] != undefined) {
			// so umm explanation can be multiple line 
			var explantion = ""
			for (var i = 2; i < example.value.split("\n").length; i++) {
				explantion += example.value.split("\n")[i] 
				}
			examples[`Example${example_count}`]["Explanation"] = explantion
			}

		example_count += 1

		}	

	console.log(examples)

	try {
		var body = {"question": question, 
		"problem_statement": problem_statement,
		"test_cases": test_cases,
		"examples": examples
		} 

		var req = await fetch("http://localhost:9005/add_question", {
			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})

	}

	catch (err) {
		console.log(err.message)
	}

	finally {

		//switching to welcome page for update
	//window.location.replace("./welcome_page.html")

	}
}

function addParameterSlots() {

	// var confirm_button_batched = document.getElementsByClassName("add_button")

	// for (var i = 0; i < confirm_button_batched.length; i++) {
	// confirm_button_batched[i].addEventListener('click', addSlots, false)

	// }

	addSlots()

	function addSlots() {

		// cannot append under input element, has to be div/container
		var parent = document.getElementById(`individual_slot${test_case_count}`)
		var parameter_count = document.getElementById("parameter_count").value // in this count this.id gives button id which is test_case_count same for all

		// disabling button after click to avoid bugs
		// var curr_button = document.getElementById(`add_button${getNumberFromString(parent.id)}`)
		// curr_button.disabled = true

		// +1 for output 
		for (var i = 0; i < Number(parameter_count) + 1; i++) {

			console.log('bonk=jour')

			// creating parameter elements
			var param_input = document.createElement("input")
			var value_input = document.createElement("input")
			var line_break = document.createElement("br")

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

var example_field_count = 0

function createExampleFields() {

	example_field_count += 1

	var example_field_parent = document.getElementById("examples")

	// containerization here to scalability, reusing delete function above
	var container = document.createElement("div")
	container.id = `example_field${example_field_count}`

	// text area add
	var text_area = document.createElement("textarea")
	text_area.id = `textarea${example_field_count}`
	text_area.textContent = "Input: \nOutput: "
	text_area.className = 'example'

	// delete button add for examples, should be renamed class name to avoid collision
	var delete_button = document.createElement("button")
	delete_button.id = `delete_example${example_field_count}`
	delete_button.className = "delete_examples"
	delete_button.innerHTML = "delete"

	line_break = document.createElement("br")
	container.appendChild(line_break)


	example_field_parent.appendChild(container)

	container.appendChild(text_area)

	line_break = document.createElement("br")
	container.appendChild(line_break)

	container.appendChild(delete_button)


	addDeleteEvent(delete_button.className, "example_field")
}
