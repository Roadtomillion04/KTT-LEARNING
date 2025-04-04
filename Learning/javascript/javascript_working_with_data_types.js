let name = "NIRMAL KUMAR R";

console.log(name.length);

console.log(name.charAt(0));

console.log(name[0])

console.log(name.indexOf("R"));

console.log(name.lastIndexOf("R"));

console.log(name.indexOf("r"));

name = name.trim();

console.log(name);

name = name.toUpperCase();

console.log(name);

name = name.toLowerCase();

console.log(name);

name = name.repeat(3);

console.log(name);

var result = name.startsWith(" ");

console.log(result);

// does not work if Capitalize letters are given
result = name.startsWith("N")

console.log(result);

result = name.startsWith("n")

console.log(result);

result = name.endsWith(" ");

console.log(result);

result = name.includes(" ku");

console.log(result);

let number = "111-222-3333";

number = number.replaceAll("-", "");

console.log(number);

number = "111-222-3333";

number = number.replace("-", "");

console.log(number);

number = number.padStart(15, "0");

console.log(number);

number = "111-222-3333";

number = number.padEnd(15, "e");

console.log(number);

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

numbers.splice(4, 1);

console.log(numbers);




