<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Diffs</key>
	<array>
		<dict>
			<key>ModifiedContent</key>
			<string>var a = "3"

var b: Int = Int(a)!

var c: String = String(b)

print(b + 3)

print(c + "b")

enum Menu {
    case start
    case options
    case quit
    
    case volume_up
    case volume_down
}

func toggle_menu(menu: Menu?) {
    
    switch menu {
    case .options:
        print("on option menu")
        
    case .quit:
        print("quiting")
        
    case .volume_up, .volume_down:
        print("volume adjustments")
        // fallthrough is like run this and also run the next case also
        
    default:
        print("at start option")
    }
    
}


toggle_menu(menu: Menu.options)
toggle_menu(menu: Menu.volume_up)

var titles: Array&lt;String&gt; = ["GOW", "LN1", "LADIW"]

var dlc: [Bool] = [true, false, false]

// varible must be defined like python, for dict could also use [:] 
var is_dlc: Dictionary&lt;String,Bool&gt; = Dictionary()

for (title, dlc_status) in zip(titles, dlc) {
    is_dlc[title] = dlc_status
}

print(is_dlc.keys)
print(is_dlc.values)

// inclusive both sides, use ..&lt; to not include last val
for i in 1...2 {
    print(i)
}

// Array is hetrogeneous (same type by default) to make it list in python
var collections: [Any] = ["Hi", 200, true]


// honesetly, I don't get the point of labels,
test_label: for i in 3...5 {
    test_label2: for j in 1...5 {
        
        if i == 4 {
            break test_label2
        }
            
        print("\(i) times \(j) = \(i * j)")
    }
}

// multiple values can be returned with tuple, and only tuple is immutable in swift
func testing() -&gt; (String, Int){
    return ("hi", 3)
}

var test = testing()

print(test)

// improves readabily?
func my_name(name player_name: String) {
    print("hello \(player_name)")
}

// argument label
my_name(name: "Nirmal")


// inout - changes apply outside scope, also parameter in func are constant by default, Void is just ()
func reset(_ lives: inout Int, _ player: inout String) -&gt; Void {
    lives = 3
    player = "default"
}

var curr_lives = 0
var player_name = "Player1"

// passing reference?
reset(&amp;curr_lives, &amp;player_name)

print(curr_lives, player_name)

// higher order functions is supported (calling func in func parameter)
func subtract(_ a: Int, _ b: Int) -&gt; Int {
    return a - b
}

// this is actually great way instead of if else checks
func calc(_ action: (Int, Int) -&gt; Int, _ a: Int, _ b: Int) -&gt; Int {
    return action(a, b)
}

var res = calc(subtract, 4, 2)
print("sub \(res)")

// return a function in a function
func step_forth(_ step: Int) -&gt; Int {
    return step + 1
}

func step_back(_ step: Int) -&gt; Int {
    return step - 1
}


func select_right_step(_ curr_step: Int) -&gt; (Int) -&gt; Int {
    return curr_step &gt; 0 ? step_back : step_forth
}


// Ik this is confusing, all because of return type is -&gt; (Int) -&gt; Int
var moving_to_zero = select_right_step(3)

print(moving_to_zero(5))


</string>
			<key>ModifiedRange</key>
			<string>{1, 2847}</string>
			<key>OriginalContent</key>
			<string></string>
			<key>OriginalRange</key>
			<string>{1, 0}</string>
		</dict>
	</array>
	<key>FormatVersion</key>
	<integer>2</integer>
</dict>
</plist>
