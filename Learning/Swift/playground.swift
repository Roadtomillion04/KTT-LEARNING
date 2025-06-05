<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BaseFile</key>
	<string>Chapters/Chapter1.playgroundchapter/Pages/Template.playgroundpage/main.swift</string>
	<key>Diffs</key>
	<array>
		<dict>
			<key>ModifiedContent</key>
			<string>// raw values in enum
enum Titles: Double, CaseIterable {
    
    case VLN = 8
    case LN = -1
    case NA = 7
    case TINGWD = 7.5
    
}

func title_rating(on title: Titles) -&gt; Void {
    
    var e = Titles(rawValue: title.rawValue) 
    
    switch e {
    case .LN, .NA, .TINGWD, .VLN:
        print("found")
    
        
    default:
        print("not found")
    }

    
    
    for _title in Titles.allCases {
        print(_title.rawValue)
    }
    

}

title_rating(on: .NA)

// associated values in enum
enum Travel {
    case car(_ mode: String, _ cost: Int)
    case Bus(mode: String, cost: Int)
    
    // whereever closure exist it is a function!
    var get_values: (String, Int) {
        switch self {
        
        // new var need to be created, and it can be any name
        case .car(let mode, let cost):
            return (mode, cost)
            
        case .Bus(let mode, let cost):
            return (mode, cost)
            
        }

    }
}

var travel: Travel = .car( "private", 1000)

//travel = .Bus(mode: "public", cost: 100)

// tuple indexing is kinda weird ik
print(travel.get_values.0)


// generics - &lt;T&gt; is type, it's just telling param to accept any data type as argument value 
func print_val&lt;T&gt;(_ val: T) {
    print(val)
}


print_val(1)


func find_greater&lt;T: Comparable&gt;(_ x: T, _ y: T) {
    print(x, y)
}

find_greater(3, 3)

var my_list: [String] = ["1", "2", "3", "a"]

print(my_list[3].uppercased())

for i in 0...my_list.count - 1 {
    print(my_list[i])
}

print(1_000_00 / 0_1_0_0_0)

// imp in for loop, functions
// parameter will be constant by default, to modify it you need to declare var name like for var name in my_list, func foo(var a, var b) like this

label: repeat {
    print(1)
    break label
} while true

var my_str: String = "34"

print("sds" + " " + my_str)


print(String(34))

// Codable - pure swift? for backwards compatible NSCoding 


my_list += ["", "10"]

print(my_list)


// Variadic parameters/ function overload

func add_nums(_ nums: Int...) -&gt; Int {
    
    var total: Int = 0
    for num in nums {
        total += num
    }
    
    return total
}

// print is also a variadic function
print(add_nums(1, 2, 3, 4, 5))


// private var cannot be accessed outside scope
struct Rectangle {
    private var _h: Double = 4.5
    private var  _w: Double = 7.0
    
    // computed property
    var height: Double {
        _h
    }
    
    // or use init() self to access inside scope
}

var rect = Rectangle()
print(rect.height)

// nil can be returned in init() with init?
struct Struct1 {
    var num: Int
    
    init(num: Int) {
        print("sruct1 is initialized")
        
        self.num = num
    }
    
    
    mutating func addOne() {
        self.num += 1
    }
}

var struct1: Struct1 = Struct1(num: 3)
struct1.addOne()

print(struct1.num)

class Class1 {
    // private(set) - only setter becomes inaccisible, private disables get and set, so you can't access this var in instance
    private(set) var name: String 
    
    init(name: String) {
        self.name = name
    }
    
    func addSuffix() {
        self.name = self.name + "Time"
        
        print(self.name)
    }
    
    deinit {
        print("deinitalized")
    }
    
}

var name1: Class1 = Class1(name: "N")
name1.addSuffix()

print(name1.name)


// the object is set to be auto deinitialized when it exits scope or assign to nil with Optional

var name2: Class1? = Class1(name: "L")

print(name2!.name)

name2 = nil


var closure = {
    var name3: Class1 = Class1(name: "K")
    
    print(name3.name)
}

closure()

// protocol is like interface in Objective C but cannot implement the function body within itself

protocol protocol1 {
    func define() 
}

// to add function body to it use extension

extension protocol1 {
    func define() {
        print("protocol defined")
    }
}

struct Definition: protocol1 {}

var defintion: Definition = Definition()
defintion.define()


// on var declaration protocol must have explicit {get set} specification
protocol protocol2 {
    var name: String { get }
    // var number: Int { set } - set alone not possible
    var num: Int { get set }
    
    // and also in protocol functions cannot have closures { } this.
}

extension protocol2 {
    // initialized values can be accessed here, either x or self.x both works and also as the functions are defined in extension, the class/struct conforms this
    func describe() -&gt; String {
        return "name: \(name), num: \(num)"
    }
    
    mutating func numOne() -&gt; Int {
        self.num = 1
        return self.num
    }
}

class myClass: protocol2 {
    var name: String
    var num: Int
    
    init(name: String, num: Int) {
        self.name = name
        self.num = num
    }
    
}


// protocol type 
var my_class: protocol2 = myClass(name: "Nim", num: 44)

print(my_class.name)
print(my_class.num)
print(my_class.describe())
my_class.numOne()
print(my_class.num)


// cannot set property to name
// my_class.name = "Nil"


protocol protocol3 {
    var title: String { get }
    var rating: Double { get set }
    
    mutating func summary() -&gt; String 
}

extension protocol3 {
    mutating func summary() -&gt; String {
        self.rating = self.rating / 2
        return "\(title) rating: \(self.rating)"
    }

}

struct consoleGame: protocol3 {
    var title: String
    var rating: Double
    
    // swift auto creates memberwise initializers in struct by default
}

var console_game: protocol3 = consoleGame(title: "LN", rating: 10)

print(console_game.summary())

// is keyword used to confirm whether object conforms protocol
print(console_game is protocol3)
// and also class/struct
print(console_game is consoleGame)

// convenience init is just fancy way of defining default init memebers, I don't see it otherwise






</string>
			<key>ModifiedRange</key>
			<string>{0, 5841}</string>
			<key>OriginalContent</key>
			<string></string>
			<key>OriginalRange</key>
			<string>{0, 0}</string>
		</dict>
	</array>
	<key>FormatVersion</key>
	<integer>2</integer>
</dict>
</plist>
