//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


/*----------Higher order func-------*/

func incrementArray(xs: [Int])->[Int] {
    var result: [Int] = []
    for x in xs {
        result.append(x+1)
    }
    return result
}

incrementArray(xs: [1,2,3,4])


func computeIntArray(xs:[Int], f:(Int)->Int)->[Int] {
    var result: [Int] = []
    
    for x in xs {
        result.append(f(x))
    }
    
    return result
}

func doubleArray2(xs: [Int])->[Int] {
    return computeIntArray(xs: xs){x in x * 2}
}

doubleArray2(xs: [1,2,3,4,5])


class Stack<element> {
    var items:[element] = []
    
    func push(item:element) {
        self.items.append(item)
        print(self.items)
    }
    
    func pop() {
        self.items.popLast()
        print(self.items)
    }
}

let s = Stack<String>()
s.push(item: "Hello")
s.pop()

/*-------------Initialize Struct class using Generics and bounding for b->child1,child2-----*/

struct b<T> {
    var resp: T?
    var meta: metaResp?
    
    init?(input:Dictionary<String,Any>,resp: T) {
        self.resp = resp
        let bin:[String:Any] = input["base"] as! [String : Any]
        meta = metaResp.init(input: bin["meta"] as! Dictionary<String, Any>)
    }
    
    func dictionaryRepresentation()->[String:Any] {
        var dictionary: [String: Any] = [:]
        if let value = meta { dictionary["meta"] = value.dictionaryRepresentation() }
        if resp != nil { dictionary["response"] = resp.map({$0}) }
        return dictionary
    }
}

struct metaResp{
    let status:Bool?
    let message:String?
    let code:Int?
    init(input:Dictionary<String,Any>) {
        self.status = input["status"] as! Bool?
        self.code = input["code"] as! Int?
        self.message = input["message"] as! String?
    }
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["status"] = status
        if let value = code { dictionary["code"] = value }
        if let value = message { dictionary["message"] = value }
        return dictionary
    }
}

struct loginResp{
    var email:String?
    var name:String?
    var hoi:String? = ""
    init(input:Dictionary<String,Any>) {
    self.email = input["email"] as! String?
    self.name = input["name"] as! String?
    self.hoi = "io"
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["email"] = email
        if let value = name { dictionary["name"] = value }
        dictionary["hoi"] = hoi
        return dictionary
    }
}

struct homeResp{
    var flips:[Int]?
    var ownerId:Int?
    init(input:Dictionary<String,Any>) {
        self.flips = input["flips"] as! [Int]?
        self.ownerId = input["ownerId"] as! Int?
    }
}

let loginResponse:[String:Any] = ["base":["meta":["status":true,"code":200,"message":"login success"]],"response":["email":"a@a.com","name":"apple"]]

let homeResponse:[String:Any] = ["base":["meta":["status":true,"code":200,"message":"home success"]],"response":["flips":[1,2,3],"ownerId":100]]

let l = b<loginResp>(
    input:loginResponse,
    resp:loginResp.init(input: loginResponse["response"] as! Dictionary<String, Any>))
print(l?.resp?.name as Any)
print(l?.meta?.message as Any)


if let r = b<homeResp>(input:homeResponse,resp:homeResp.init(input: homeResponse["response"] as! Dictionary<String, Any>)) {
    print(r.meta?.message as Any)
    print(r.resp?.flips as Any)
    print(r.resp?.ownerId as Any)
}


func returnBVal()->b<loginResp> {
    return b<loginResp>(
        input:loginResponse,
        resp:loginResp.init(input: loginResponse["response"] as! Dictionary<String, Any>))!
}

let lol = returnBVal()

//typealias T = tostruct
typealias returkBlock = (Any?)->Void

final class Webservice {
    func load(resource: URL, completion: @escaping returkBlock) {
        URLSession.shared.dataTask(with: resource) { data, _, _ in
//            guard data != nil else {
//                completion(nil)
//                return
//            }
          let br = b<loginResp>(
                input:loginResponse,
                resp:loginResp.init(input: loginResponse["response"] as! Dictionary<String, Any>))
            completion(br!)
            }.resume()
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

Webservice.init().load(resource: URL.init(string: "www.google.com")!, completion: {result in
    let bc = result as! b<loginResp>
    print(bc.resp!)
    print(bc.dictionaryRepresentation())
})











