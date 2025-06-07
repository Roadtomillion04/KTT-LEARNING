// raw values in enum
enum Titles: Double, CaseIterable {
    
    case VLN = 8
    case LN = -1
    case NA = 7
    case TINGWD = 7.5
    
}

func title_rating(on title: Titles) -> Void {
    
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


// generics - <T> is type, it's just telling param to accept any data type as argument value 
func print_val<T>(_ val: T) {
    print(val)
}


print_val(1)


func find_greater<T>(_ x: T, _ y: T) {
    print(x, y)
}

find_greater(3, 3)


var my_list: [String] = ["1", "2", "3", "a"]

// but could not do uppercase on string char with Any, cause it's all server side
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

func add_nums(_ nums: Int...) -> Int {
    
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
    
    // cannot be accessed by instances
    private func _unknown() {
        
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
    func describe() -> String {
        return "name: \(name), num: \(num)"
    }
    
    mutating func numOne() -> Int {
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
    
    mutating func summary() -> String 
}

extension protocol3 {
    mutating func summary() -> String {
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

protocol protocol4 {
    var speed: Int { get set }
    
    func curr_speed() -> String
}

extension protocol4 {
    func curr_speed() -> String {
        return "current speed at \(self.speed) KMPH"
    }
}

class Car: protocol4 {
    var speed: Int 
    var model: String
    
    init(speed: Int, model: String) {
        self.speed = speed
        self.model = model
    }
    
    // convenience init can be added down here or in extension
}

extension Car {
    // no self.x is needed in convenience init
    convenience init(speed: Int) {
        self.init(speed: speed, model: "unknown")
    }
}


var my_car: protocol4 = Car(speed: 40)
print(my_car.curr_speed())

// extension can be added any number of times

extension protocol4 {
    func addSpeed(_ add_speed: Int) -> String {
        return "car now can go in \(self.speed + add_speed) KMPH"
    }
}

print(my_car.addSpeed(5))

// can also extend pre defined classes
extension Int {
    // here the Self referes to Int type, self is value it holds
    mutating func add(_ a: Int) -> Self {
        // self is Int
        self += a
        
        return self
    }
}

var my_num = 50
print(my_num.add(50))

print(my_num)


// Generics with accepting more type with &
protocol Walk {
    func can_walk() -> String
}

protocol Run {
    func can_run() -> String
}

// conform multiple protocols
struct Person: Walk, Run {
    func can_walk() -> String {
        return "walking"
    }
    
    func can_run() -> String {
        "running" // for one lines return keyword is optional
    }
    
}


// let's say what if I need a function 
//func walk_and_run(walk: Walk, run: Run) {} not like this but generic function signature, having multiple protocols

func walk_and_run<T: Walk & Run>(_ param: T) -> (String, String) {
    return (param.can_walk(), param.can_run())
}

var person = Person()
print(walk_and_run(person))


// only string arrays are effected
extension Array<String> {
    
    // optional is just value or nil, used here for empty array tho it's not possible to call this function on empty array
    func findZero() -> String? {
        
        var index: Int = 0
        
        for i in 0...self.count - 1 
        {
            if self[i] == "0" {
                index = i
                break
            }
        }
        
        // in swift return is valid only at last?? and cannot find the i? I miss python
        return "zero found at \(index)"
        
    }
}

// shorthand if and also unwraps optional, can also use guard but it expects else 
if let zero_arr = ["1", "2", "0"].findZero() {
    print(zero_arr)
}

// assosciated types
// according to what I understood they are placeholder datatype, when you are uncertain about what 

protocol assosiated_types {
    // could be Array of Int, Double, String
    associatedtype DataType
    
    var my_collection: Array<DataType> { get set }
    
    func desc_type()
}

extension assosiated_types {
    
    func desc_type() {
        print(type(of: my_collection))
    }
}


// Now we can have struct for Int
struct IntCollection: assosiated_types {
    
    var my_collection: Array<Int>
    
    init(collection: Array<Int>) {
        self.my_collection = collection
    }
    
}

// and string datatypes conforming single protocol
struct StringCollection: assosiated_types {
    
    var my_collection: Array<String>
    
    init(collection: Array<String>) {
        self.my_collection = collection
    }
    
}



var int_collection = IntCollection(collection: [1, 2, 3])
var str_collection = StringCollection(collection: ["a", "b", "c"])

int_collection.desc_type()
str_collection.desc_type()


// generics
// avoid duplicating reuse the code wherever possible, for example if I do + operation for Int and Double, I don't need to write two function

func numeric_add<N: Numeric>(_ x: N, _ y: N) -> N {
    return x + y
}

// this retains as Int
print(numeric_add(5, 5), type(of: numeric_add(5, 5)))

// and this as Double
print(numeric_add(6.3, 4.2), type(of: numeric_add(6.3, 4.2)))


// Error Handling
struct PersonInfo {
    var first_name: String?
    var last_name: String?
    
    // one common practice is to store the Errors in enum (Error protocol) and match it with switch case, these are custom errors
    enum NameErrors: Error {
        case FirstNameEmpty
        case LastNameEmpty
        case BothNameEmpty
    }
    
    // throws key word used
    func fullName() throws -> String? {
        switch (first_name, last_name) {
        case (.none, .none):
            throw NameErrors.BothNameEmpty
            
            // .some represents there exist value 
        case (.none, .some):
            throw NameErrors.FirstNameEmpty
            
        case (.some, .none):
            throw NameErrors.LastNameEmpty
        
        // use ! when you are sure it's not nil, it unwraps
        case (.some, .some) :
            return "FullName: \(first_name!) \(last_name!)"
            
        }

    }
    
}

var person1: PersonInfo = PersonInfo()
var person2: PersonInfo = PersonInfo(first_name: "L", last_name: "L")

// error checking done in try catch
do {
    let p1_full_name: String? = try person1.fullName()
    
    // lines after try will not be executed if error as we are throwing error to catch with the function above
    
} catch {
    print("Error: \(error)")
}


do {
    // I think try is messing up with let unwrap, so just use !
    if let p2_full_name: String? = try person2.fullName() {
        print(p2_full_name!)
    }
    
        
} catch {
    print("Error: \(error)")
}


// throwing error on init
struct CarModel {
    var model: String
    
    enum modelError: Error {
        case InvalidModel
    }
    
    init(_ model: String) throws {
        if model.isEmpty {
            throw modelError.InvalidModel
        }
        
        self.model = model
    }
    
}


do {
    var my_car_model: CarModel = try CarModel("")
    
    print(my_car_model.model)
}
// instance specific error
catch CarModel.modelError.InvalidModel{
    print("Invalid model")
} catch {
    print("other")
}


// according to Vandad, angry try which is try! should never be used in applications, if it fails it crashed the program
struct Cat {
    var sleep: Bool?
    var hungry: Bool?
    
    // you can't throw error, if your enum does not confirm Error protocol
    enum CatSleep: Error {
        case SleepingCat
    }
    
    enum CatHungry: Error {
        case HungryCat
    }

    
    func play() throws -> String? {
        if sleep == nil { throw CatSleep.SleepingCat }
        
        return "play"
    }
    
    func meow() throws -> String? {
        if hungry == nil { throw CatHungry.HungryCat }
        
        return "meow"
    }
    
}

var my_cat: Cat = Cat()

do {
    // rememeber only one try catch error in do
    try my_cat.play()
} catch Cat.CatSleep.SleepingCat, Cat.CatHungry.HungryCat{
    print("Error: Cat sleep or Hungry")
}
