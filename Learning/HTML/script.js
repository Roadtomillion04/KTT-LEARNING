
function update_time(){

	// get start time and end time and subtract it
	var start_time = document.getElementById("start_time").value;

	var end_time = document.getElementById("end_time").value;

	//  start and end time are strings
	// console.log(typeof start_time);
	// console.log(typeof end_time);

	var start_hour = parseInt(start_time.slice(0, 2));			
	var start_minutes = parseInt(start_time.slice(3, 5));			
	var end_hour = parseInt(end_time.slice(0, 2));			
	var end_minutes = parseInt(end_time.slice(3, 5));

	// time check
	if (start_hour > end_hour) {
		alert("start time cannot be greater");

		// reload the current document
		location.reload();

	}

	// 1:30 max hour gap

	if ((end_hour - start_hour) < 2 && (Math.abs(end_minutes - start_minutes)) <=30) {

			// update duration

			let duration = document.getElementById("duration");

			// `` this is format string and to add 0 before the one digit num which is the time format use padStart
			duration.value = `${(end_hour - start_hour).toString().padStart(2, '0')}:${Math.abs(end_minutes - start_minutes).toString().padStart(2, '0')}`;


	} else {
		alert("work log hours cannot exceed 1:30 minutes");

		location.reload();
	}

}
