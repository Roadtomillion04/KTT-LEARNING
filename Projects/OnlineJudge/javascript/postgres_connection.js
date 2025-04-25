var Client = require('pg').Client

var client = new Client({
	host: "localhost",
	user: "postgres",
	port: 5432,
	password: "Nirmal101",
	database: "test"
})

client.connect()

client.query(`SELECT * FROM hi`, function (err, res) {
	if (err) {
		console.log(err.message)
	}
	else {
		console.log(res.rows)
	}
})

client.end()