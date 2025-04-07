const new_map = new Map();

new_map.set("Hi", 15);
new_map.set("Hello", 20);
new_map.set("Ahoy", 30);

console.log(new_map.get("Hi"));

new_map.set("Hi", 100);

console.log(new_map.get("Hi"));

console.log(new_map.size);

new_map.delete("Ahoy");

console.log(new_map.size);

console.log(new_map.get("Hello"));

console.log(new_map.has("Ahoy"));

// wrong way of assinging key value pair to map
new_map["Ahoy"] = 30;

console.log(new_map);

// does not considered as part of Map
console.log(new_map.keys());
console.log(new_map.has("Ahoy"));

// map way of deleting does not work
new_map.delete("Ahoy");

console.log(new_map);

// object way of deleting works
delete new_map["Ahoy"];

console.log(new_map);

console.log(new_map.entries());

function printPairs(value, key, map) {
	console.log(value, key, map);
}

// forEach sends three arguemnts to the function that is value, key, map in this order
new_map.forEach(printPairs);


for (const [key, value] of new_map) {
	console.log(key, value);
}


const new_set = new Set();

new_set.add(10);
new_set.add(20);
new_set.add(30);

console.log(new_set);

console.log(new_set.has(20));

const hi = new Set([1, 3, 5, 7, 9]);
const hello = new Set([1, 4, 9]);

console.log(hi.difference(hello));
console.log(hello.difference(hi));

console.log(hi.union(hello));
console.log(hello.union(hi));

console.log(hi.intersection(hello));
console.log(hello.intersection(hi));

hi.clear()

console.log(hi)

