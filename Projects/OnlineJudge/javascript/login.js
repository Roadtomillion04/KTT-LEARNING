async function registerUser() {

	// get input values
	var first_name = document.getElementById("first_name").value
	var last_name = document.getElementById("last_name").value
	var email = document.getElementById("email").value
	var department = document.getElementById("department").value
	var roll_no = document.getElementById("roll_no").value
	var password = document.getElementById("password").value

	try {
		var body = {"first_name": first_name, "last_name": last_name, "email": email, "department": department, "roll_no": roll_no, "password": password}

		var req = await fetch("http://localhost:9000/user_register", {
			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})
	}

	catch (err) {
		console.error(err.message)
	}

}