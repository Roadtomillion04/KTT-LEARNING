document.addEventListener("DOMContentLoaded", initialize, false)

function initialize() {

	//

	// getFormValue()
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

	}

}