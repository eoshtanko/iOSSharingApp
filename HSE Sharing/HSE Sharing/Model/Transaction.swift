//
//  Exchange.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class Transaction: Codable, NSCoding {
    var id: Int
    var skill1: String
    var skill2: String
    var description: String
    var userName: String
    var userPhoto: Data
    // Статус: 0 - отправлен, 1 - подтвержден (активен), 2 - завершен
    var status: Int
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInteger(forKey: "id")
        skill1 = coder.decodeObject(forKey: "skill1") as! String
        skill2 = coder.decodeObject(forKey: "skill2") as! String
        description = coder.decodeObject(forKey: "description") as! String
        userName = coder.decodeObject(forKey: "userName") as! String
        userPhoto = coder.decodeObject(forKey: "userPhoto") as! Data
        status = coder.decodeInteger(forKey: "status")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(skill1, forKey: "skill1")
        coder.encode(skill2, forKey:"skill2")
        coder.encode(description, forKey: "description")
        coder.encode(userName, forKey:"userName")
        coder.encode(userPhoto, forKey: "userPhoto")
        coder.encode(status, forKey:"status")
    }
    
    var toDict: [String: Any] {
        return ["id": id,
                "skill1": skill1,
                "skill2": skill2,
                "description": description,
                "userName": userName,
                "userPhoto": userPhoto,
                "status": status
        ]
    }
}
