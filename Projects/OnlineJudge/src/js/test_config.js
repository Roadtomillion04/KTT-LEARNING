document.addEventListener("DOMContentLoaded", initialize, false)

function initialize() {

	// as the name suggests, fetch the last record if exists for viewing
	getTestConfigs()

}

async function getFormValue() {

	var test_id = document.getElementById("test_id").value

	var question_count = document.getElementById("question_count").value

	var start_time = document.getElementById("start_time").value

	var end_time = document.getElementById("end_time").value

	var date = document.getElementById("date").value


	var body = {
		"test_id": test_id,
		"question_count": question_count,
		"start_time": start_time,
		"end_time": end_time,
		"test_date": date
	}


	try {

		var post_config = await fetch("http:localhost:8999/test_config", {

			method: "POST",
			headers: {"Content-Type": "application/json"},
			body: JSON.stringify(body)

		})


	}

	catch (err) {

		console.error(err.message)

	}

	finally {

		window.location.replace("./welcome_page.html")

	}

}


async function getTestConfigs() {

	var get_config = await fetch("http://localhost:8999/get_configs", {

		method: "GET",
		headers: {"Content-Type": "application/json"}

	})

	var body = await get_config.json()

	// let's unpack the object and insert it in html page
	var container = document.getElementById("config_info")

	for ([key, val] of Object.entries(body[0])) {
		
		var pre = document.createElement("pre")

		// let's modify a bit
		if (key == "creation_id") { continue }

		if (key == "test_date") { 
			pre.textContent = key + " : " + val.slice(0, 10) 
			container.appendChild(pre)
			
			continue
		}

		pre.textContent = key + " : " + val

		container.appendChild(pre)

	}


}