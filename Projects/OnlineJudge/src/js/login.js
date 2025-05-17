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

		window.location.href = "./test_page.html"

		// forget about the cookies, it's just a headache configuring for localhost, todo later: try after deployment
		// document.cookie = `user_token=${res.token}`

	
		// now that we capture token, we gotta send it to test page 
		// sendValidToken(res)

	}

	catch (err) {
		console.error(err.message)
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