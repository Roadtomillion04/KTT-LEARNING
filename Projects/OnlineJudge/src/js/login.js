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

		var req = await fetch("http://localhost:8999/create_new_user", {
			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)
		})

		var res = await req.json()

		console.log(res.token)

		// just setItem to localstorage, don't complicate things by posting request everytime the token, for login and admin yeah
		// localStorage.setItem("user_token", res.token)

		// well let's swtich to session storage as it fits my needs more, no sharing across tabs and expires auto when tab is closed
		sessionStorage.setItem("user_token", res.token)

		getTestId()


		// forget about the cookies, it's just a headache configuring for localhost, todo later: try after deployment
		// document.cookie = `user_token=${res.token}`

	
		// now that we capture token, we gotta send it to test page 
		// sendValidToken(res)

	}

	catch (err) {
		console.error(err.message)
	}

}

// I was planning to set question count in session storage here as well, I don't want to give away all stuff you know, well nvm
async function getTestId() {

	try {

		var get_test_configs = await fetch("http://localhost:8999/get_configs", {

			method: "GET",
			headers: {"Content-Type": "application/json"}

		})

		var res = await get_test_configs.json()

		console.log(res)

		// let's set the test id in sessionStorage 
		await sessionStorage.setItem("test_id", res[0].test_id)

		// and no. of questions
		await sessionStorage.setItem("no_of_questions", res[0].question_count)

	}

	catch (err) {
		console.error(err.message)
	}

	finally {
		window.location.href = "./code_editor.html"
	}



}


// so the initial plan was to post token to express, now I'll just use localStorage
// async function sendValidToken(body) {

// 	try {

// 		console.log("hihi")


// 		// so post expects to get response or it'll loop and no go to finally
// 		var send_token = await fetch("http://localhost:8999/user_generated_token", {

// 			method: "POST",
// 			headers: {"Content-Type": "application/json"},
// 			body: JSON.stringify(body)

// 		})

// 	}

// 	catch (err) {
// 		console.error(err.message)
// 	}

// 	finally {
// 		window.location.href = "./test_page.html"
// 	}


// }