//1. init() vs init?()
// init() initializes given value, but what if we some constraints like password in that case we use init?() to return nil if fails

class Email {
    var mail_id: String 
    var password: String
    
    // init becomes optional, falliable init
    init?(email: String, password: String) {
        if email.hasSuffix("@gmail.com") {
            self.mail_id = email
        } else { return nil }
        
        if password.count >= 8 {
            self.password = password
        } else { return nil }
    }
}

// instance should be optional
var my_email: Email? = Email(email: "nirmal@gmail.com", password: "12345678")

// to unwrap optional
print(my_email!.mail_id, my_email!.password)


//2. self vs Self
// self is value, Self is type

extension Double {
    func ceil() -> Self {
        return self + 0.7 
    } 
}

var my_double: Double = 4.3
print(my_double.ceil())


//3. == and ===
// == check equal value, === check class reference

class myClass {
    var val: Int
    
    init(val: Int) {
        self.val = val
    }
}

var my_class: myClass = myClass(val: 4)

var my_class_copy = my_class

print(my_class === my_class_copy)

var my_class2: myClass = myClass(val: 7)

// no same reference, so false
print(my_class === my_class2)


//4. Protocol extension must store computed properties x { 10 }, stored property is x = 10 extensions must not contain it


protocol Mob {
    
    var hp: Int { get set }
    var attack: Int { get set }
    var _class: String { get }
    
    func navigation() -> String
    
}


extension Mob {
    
    var base_hp: Int { 10 }
    var base_attack: Int { 5 }    
    
    func navigation() -> String {
        return "idle"
    }
   
}


class Slime: Mob {
    var hp: Int
    var attack: Int
    var _class: String = "Slime"
    
    init(hp: Int = -1, attack: Int = -1) {
        self.hp = hp
        self.attack = attack
        
        // can be accessed only after init
        if self.hp == -1 {
            self.hp = self.base_hp
        }
        
        if self.attack == -1 {
            self.attack = self.base_attack
        }

    }

    
    
}


var easy_slime: Mob = Slime()
print(easy_slime.hp, easy_slime.attack, easy_slime.navigation())

var medium_slime: Mob = Slime(hp: 20, attack: 10)
print(medium_slime.hp, medium_slime.attack, medium_slime.navigation())


// chaining and optional

struct House {
    var rooms: Int
    var floors: Int
    var address: Address?
    
    struct Address {
        var city: String
        var street: String?
    }

}

var house1: House = House(rooms: 4, floors: 1, address: House.Address(city: "NYC", street: nil))

// let is for unwrapping optional and decalring it, house_street scope ends with if scope
if let house_street = house1.address?.street {
    print("House is at \(house_street)")
} else {
    print("no info")
}

// swift auto assigns nil if not initialize optional member
var house2: House = House(rooms: 2, floors: 2)

print(house2.address)

//
var house3: House = House(rooms: 5, floors: 0, address: House.Address.init(city: "Tokyo", street: nil))

switch house3.address?.street {

// let var grabs the switch item value
case let .some(street): 
    print("street is at " + street)

// aslo where can be used here, this case will never be checked because the above case has no constraints and breaks the switch
case let .some(street) where street.count == 0:
    print("Ivalid street address!")
    
case .none: // none case check
    print("No optional value given")
}



