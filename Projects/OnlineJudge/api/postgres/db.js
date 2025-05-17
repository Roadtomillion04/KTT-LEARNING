var Pool = require('pg').Pool
// pool for parallel connections/ Client single connection

// open connection to the database
var pool = new Pool({
	host: "localhost",
	user: "postgres",
	port: 5432,
	password: "Nirmal101",
	database: "test"
})

module.exports = pool

// 	pool.connect()

// 	pool.query(`INSERT INTO user_register (first_name, last_name, email, department, roll_no, user_password, registration_time) 
// VALUES ('${first_name}', '${last_name}', '${email}', '${department}', '${roll_no}', '${password}', '2025-04-23 18:15:45.006124');`, function (err, res) {
// 	if (err) {
// 		console.log(err.message)
// 	}
// 	else {
// 		console.log(res.rows)
// 	}

// })
	// this was the issue not quering
	// pool.end()