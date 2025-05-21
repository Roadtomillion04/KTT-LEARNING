var express = require('express')
var router = express.Router()
var pool = require('../postgres/db.js')

// so maybe handle time remaining in server?
router.get("/time_remaining", async function (req, res) {

	// let's get end time first
	var query = `SELECT end_time FROM TEST_CONFIG ORDER BY creation_id DESC LIMIT 1`

	var get_time = await pool.query(query)

	var {end_time} = get_time.rows[0]

	// var now = Date.now()

	// console.log(Math.floor(now/1000))
	
	var date_obj = new Date()

	var now = date_obj.toTimeString().slice(0, 8)

	// let's just subtract manually, phew this works somehow correctly
	var hour = Math.abs(Number(end_time.slice(0, 2)) - Number(now.slice(0, 2))) - 1

	var min = Math.abs(Number(end_time.slice(3, 5)) - Number(now.slice(3, 5))) - 60

	var sec = Math.abs(Number(end_time.slice(6, 8)) - Number(now.slice(6, 8))) - 60

	// let's remove negative if present
	hour = Number(hour)
	min = Number(min)
	sec = Number(sec)

	if (hour < 0) { hour = hour * -1 }
	if (min < 0) { min = min * -1 }
	if (sec < 0) { sec = sec * -1 }

	res.json({"hour": hour, "min": min, "sec": sec})

})


module.exports = router