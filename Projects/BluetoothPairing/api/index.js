let express = require('express')
let dotenv = require('dotenv')

let app = express()
app.use(express.json())

dotenv.config({path: './.env'})


let APPLICATION_ID = process.env.APPLICATION_ID
let REST_API_KEY = process.env.REST_API_KEY


let macMap = {
  "lock1": "00:00:00:00:00:00",
  "lock2": "00:00:00:00:00:01"
}


let lockLogs = []

// verify key before proceeding to return json response
function authenticateKey(req, res, next) {

    let applicationId = req.header('APPLICATION_ID')
    let restApiKey = req.header('REST_API_KEY')    

    if (applicationId !== APPLICATION_ID || restApiKey !== REST_API_KEY) {
		
        res.json({
           success: true,
           error: 'Unauthorized'
  	   })
	   
    }
    
	next()
}


app.get('/api/locks/mac', authenticateKey, function (req, res) {

    res.json({
      success: true,
      response: macMap
  })

})


app.get('/api/locks/mac/:lockName', authenticateKey, function (req, res) {
   
    let {lockName} = req.params

   // if lockName in macMap {
		
	 	res.json({
	        success: true, 
	        response: macMap[lockName]
	    })	
		
    //}
 
//	else {
		
//		res.json({
//			success: true.
//			error: "lock name does not exist"
//		})
		
//	}

})



app.post('/api/logs', authenticateKey, function (req, res) {
	
	let body = req.body
	
	console.log(body)

	
})



app.listen(9000, function () {})


