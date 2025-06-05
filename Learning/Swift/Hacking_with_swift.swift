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
        
        if password.count &gt;= 8 {
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
    func ceil() -&gt; Self {
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


//4. 
