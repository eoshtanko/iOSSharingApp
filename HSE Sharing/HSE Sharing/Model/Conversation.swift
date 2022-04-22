//
//  File.swift
//  ChatApp
//
//  Created by Екатерина on 06.03.2022.
//

import UIKit

class Conversation: Codable, NSCoding {

    let id: Int64
    let lastMessage: String
    let sendTime: String
    let mail1: String
    let name1: String
    let surname1: String
    let photo1: String?
    let mail2: String
    let name2: String
    let surname2: String
    let photo2: String?
    var users: [User]?
    
    init(id: Int64, lastMessage: String, sendTime: String, mail1: String, name1: String, surname1: String, photo1: String?, mail2: String, name2: String, surname2: String, photo2: String?, users: [User]?) {
        self.id = id
        self.lastMessage = lastMessage
        self.sendTime = sendTime
        self.mail1 = mail1
        self.name1 = name1
        self.surname1 = surname1
        self.photo1 = photo1
        self.mail2 = mail2
        self.name2 = name2
        self.surname2 = surname2
        self.photo2 = photo2
        self.users = users
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInt64(forKey: "id")
        lastMessage = coder.decodeObject(forKey: "lastMessage") as! String
        sendTime = coder.decodeObject(forKey: "sendTime") as! String
        mail1 = coder.decodeObject(forKey: "mail1") as! String
        name1 = coder.decodeObject(forKey: "name1") as! String
        surname1 = coder.decodeObject(forKey: "surname1") as! String
        photo1 = coder.decodeObject(forKey: "photo1") as? String
        mail2 = coder.decodeObject(forKey: "mail2") as! String
        name2 = coder.decodeObject(forKey: "name2") as! String
        surname2 = coder.decodeObject(forKey: "surname2") as! String
        photo2 = coder.decodeObject(forKey: "photo2") as? String
        users = coder.decodeObject(forKey: "users")  as? [User]
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(lastMessage, forKey: "lastMessage")
        coder.encode(sendTime, forKey:"sendTime")
        coder.encode(mail1, forKey: "mail1")
        coder.encode(name1, forKey:"name1")
        coder.encode(surname1, forKey: "surname1")
        coder.encode(photo1, forKey:"photo1")
        coder.encode(mail2, forKey: "mail2")
        coder.encode(name2, forKey:"name2")
        coder.encode(surname2, forKey: "surname2")
        coder.encode(photo2, forKey:"photo2")
        coder.encode(users, forKey:"users")
    }
}

extension Conversation {
    
    var toDict: [String: Any] {
        return [
            "id": id,
            "lastMessage": lastMessage,
            "sendTime": sendTime,
            "mail1": mail1,
            "name1": name1,
            "surname1": surname1,
            "photo1": photo1 as Any,
            "mail2": mail2,
            "name2": name2,
            "surname2": surname2,
            "photo2": photo2  as Any,
        ]
    }
    
    func getDictUsers() -> [[String: Any]] {
        var dict: [[String: Any]] = []
        for user in users! {
            dict.append(user.toDict)
        }
        return dict
    }
}

extension Conversation: Comparable {
    
  static func == (lhs: Conversation, rhs: Conversation) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Conversation, rhs: Conversation) -> Bool {
      return lhs.sendTime > rhs.sendTime
  }
}
