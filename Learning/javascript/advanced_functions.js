var myObj = { 'name':"John", "age":31, "city":"New York" };
var myJSON = JSON.stringify(myObj);
console.log(myJSON);

var parse = JSON.parse(myJSON);

console.log(parse);

function call1(a) {

	console.log(a)

	if (a == 1) {
		return
	}

	a--

	return call1(a)
}

call1(5)

let arr = [3, 5, 1];
let arr2 = [8, 9, 15];

let merged = [0, ...arr, 2, ...arr2];

console.log(merged);
console.log(merged[6]);

let name = "NIRMAL"

console.log(...name)
console.log([...name])

class Phone {

	constructor(model, price) {
		this.model = model
		this.price = price
	}

	addTax(tax) {
		return this.price + (this.price * tax)
	}
}

realme = new Phone("6T", 29000)

console.log(realme.model)
console.log(realme.addTax(0.05))

class Device {

	constructor(model, price) {
		this.model = model
		this.price = price
	}

	addTax(tax) {
		return this.price + (this.price * tax)
	}
}

class Laptop extends Device {
	constructor(brand, model, price) {
		super(model, price)
		this.brand = brand
	}
}

laptop1 = new Laptop("Apple", "M1", 60000)

console.log(laptop1)
console.log(laptop1.addTax(0.08))