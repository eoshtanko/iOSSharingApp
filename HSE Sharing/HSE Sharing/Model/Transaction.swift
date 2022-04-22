//
//  Exchange.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class Transaction: Codable, NSCoding {
    var id: Int64
    var skill1: String
    var skill2: String
    var description: String
    var senderMail: String
    var receiverMail: String
    var whoWantMail: String
    // Статус: 0 - отправлен, 1 - подтвержден (активен), 2 - завершен
    var status: Int
    var users: [User]?
    
    init(id: Int64, skill1: String, skill2: String, description: String, senderMail: String, receiverMail: String, whoWantMail: String, status: Int, users: [User]?) {
        self.id = id
        self.skill1 = skill1
        self.skill2 = skill2
        self.description = description
        self.senderMail = senderMail
        self.receiverMail = receiverMail
        self.whoWantMail = whoWantMail
        self.status = status
        self.users = users
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInt64(forKey: "id")
        skill1 = coder.decodeObject(forKey: "skill1") as! String
        skill2 = coder.decodeObject(forKey: "skill2") as! String
        description = coder.decodeObject(forKey: "description") as! String
        senderMail = coder.decodeObject(forKey: "senderMail") as! String
        receiverMail = coder.decodeObject(forKey: "receiverMail") as! String
        whoWantMail = coder.decodeObject(forKey: "whoWantMail") as! String
        status = coder.decodeInteger(forKey: "status")
        users = coder.decodeObject(forKey: "whoWantMail") as? [User]
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(skill1, forKey: "skill1")
        coder.encode(skill2, forKey:"skill2")
        coder.encode(description, forKey: "description")
        coder.encode(senderMail, forKey:"senderMail")
        coder.encode(receiverMail, forKey: "receiverMail")
        coder.encode(whoWantMail, forKey: "whoWantMail")
        coder.encode(status, forKey:"status")
        coder.encode(users, forKey: "users")
    }
    
    var toDict: [String: Any] {
        return [
                "skill1": skill1,
                "skill2": skill2,
                "description": description,
                "senderMail": senderMail,
                "receiverMail": receiverMail,
                "whoWantMail": whoWantMail,
                "status": status,
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
