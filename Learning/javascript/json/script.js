
async function fetchCharacter() {

var id = document.getElementById("character").value

var character_info = await fetch(`https://gsi.fly.dev/characters/${id}`)

var chara_data = await character_info.json()

console.log(chara_data)

document.getElementById("name").innerHTML = chara_data.result.name



var character_img = await fetch(`https://gsi.fly.dev/characters/${id}/media`).then(response => response.clone().json())

// var chara_img = await character_info.clone().json()
	
console.log(character_img)

document.getElementById("charaimg").src = character_img.result.videos[0]

}