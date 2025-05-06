async function validateAdmin() {

	var username = document.getElementById("admin_name").value

	var password = document.getElementById("admin_password").value

	// instead of select * and check everything in js, i'll just send query and check with sql
	var check_valid_admin = await fetch(`http://localhost:9005/check_admin_credentials/?username=${username}&password=${password}`, {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	var body = await check_valid_admin.json()
	console.log(body)
	
	// now we know if a body is empty, admin no exist
	if (body[0] == undefined) {
		alert("Wrong Credentials!")
	}

	else {
		// let's keep the minimal header, that this person is admin
		sessionStorage.setItem("is_admin", "yes")

		// let's generate link after confirming 
		var welcome_page_link = document.createElement("a")
		welcome_page_link.innerHTML = `click to proceed, ${body[0].username}`
		welcome_page_link.href = "./welcome_page.html"

		var container = document.getElementById("page_content")

		container.appendChild(welcome_page_link)
	}


}