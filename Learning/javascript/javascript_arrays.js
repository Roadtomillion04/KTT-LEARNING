let numbers = [1, 2, 4, 8];

console.log(numbers);

numbers[4] = 16;

console.log(numbers);

numbers.push(32);

console.log(numbers);

numbers.unshift(0);

console.log(numbers);

let lastNumber = numbers.pop();

console.log(numbers);

console.log(lastNumber);

let firstNumber = numbers.shift();

console.log(numbers);

console.log(firstNumber);

// pos, elemnets to remove, "elements to add in param"
numbers.splice(4, 1, 100);

console.log(numbers);

let list = [
    {name: 'Oppo', cost: 4},
    {name: 'Oneplus', cost: 10},
    {name: 'Redmi', cost: 5},
    {name: 'Vivo', cost: 3},
    {name: 'Realme', cost: 12}
];

var total = 0;

for (let index = 0; index < list.length; index++) {
    let item = list[index];
    console.log(item)
    total += item.cost;
    }
console.log(total)


let index = 0;
let item;

while (item = list[index++]) {
    console.log(item);
}

list = ["Hi", "Hello", "Greeting", "Howdy", "Hi", "Ahoy"]

console.log(list.indexOf("Hi"))
console.log(list.indexOf("Hi", 1)) // second occurance
console.log(list.lastIndexOf("Hi"))
console.log(list.lastIndexOf("Hi", 1)) // reverse

list2 = ["bonjour", "gutentag"]

let merge = list.concat(list2) // multiple list can be given

console.log(merge)

// list can be converted to string with join same as python
console.log(list.join(" "))

long_li = [[1, 2, "test", {Greeting: {"Eng": "Hi", "French": "bonjour", "German": "gutentag"}}], {Mobiles: {"Camera": ["Oppo", "Vivo"], "Gaming": ["Poco", "Iqoo", "Realme"], "Premium": ["Iphone", "Samsung", "Oneplus"]}}]


console.log(long_li[1].Mobiles.Camera[0])
console.log(long_li[1].Mobiles.Gaming)