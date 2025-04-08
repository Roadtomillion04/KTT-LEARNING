var price = {
	"Oneplus": 400,
	"apple": 700,
	"Realme": 350
}

console.log(price)
console.log(Object.entries(price))


function inflate(rate) {
	price = Object.fromEntries(Object.entries(price).map(val => [val[0], val[1] * rate]))
}

inflate(1)

console.log(price)

var tripleprice = (discounts) => {
	var i = 0
	return Object.fromEntries(Object.entries(price).map(val => [val[0], val[1] * 3 * (100-discounts[i++])/100]))
}

console.log(tripleprice([10, 20, 15]))





