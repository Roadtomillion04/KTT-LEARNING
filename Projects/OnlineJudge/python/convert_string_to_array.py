# HTTP inbuild is hard
# Okay I figured JSON.parse() does the job very lately, but just in case if I need any python support later I'll have it here so that I can use it

from flask import Flask, request
import numpy as np

app = Flask(__name__)

@app.route("/type_cast", methods= ["GET", "POST"])
def type_cast():

	content_type = request.headers.get("Content-Type")

	if request.method == "POST" and content_type == "application/json":
			string_array: str = request.json["array"]

			valid_array = np.array(string_array)

			print(valid_array)

			return {"array": [[1, 2, 3], [2, 1]]}

app.run(debug= True)