test_case_count = 0

function createTestCaseFields() {

	//every time this function called increase count by 1 to keep track
	test_case_count += 1

	var test_case_parent = document.getElementById("test_cases")

	// text area add
	var text_area = document.createElement("textarea")
	text_area.id = `textarea${test_case_count}`
	text_area.textContent = "Input: \nOutput: "
	text_area.className = 'test_case'

	// delete button add
	var delete_button = document.createElement("button")
	delete_button.id = `delete${test_case_count}`
	delete_button.className = "delete"
	delete_button.innerHTML = "delete"

	// now that new textarea element is created, to add it to html page we need to append to parent
	test_case_parent.appendChild(text_area)
	test_case_parent.appendChild(delete_button)

	line_break = document.createElement("br")
	line_break.id = `break${test_case_count}`

	test_case_parent.appendChild(line_break)

	updateElement()
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

		var req = await fetch("http://localhost:9000/add_question", {
			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})

	}

	catch (err) {
		console.log(err.message)
	}
}
