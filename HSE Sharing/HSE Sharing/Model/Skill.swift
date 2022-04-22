//
//  Skill.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class Skill: Codable, NSCoding {
    var id: Int64
    // Статус: 1 - могу, 2 - хочу
    var status: Int
    var name: String
    var description: String
    var category: Int
    var subcategory: Int
    var userMail: String
    var userName: String?
    var userSurname: String?
    var userPhoto: String?
    
    init(id: Int64, status: Int, name: String, description: String, category: Int, subcategory: Int, userMail: String, userName: String, userSurname: String, photo: String?) {
        self.id = id
        self.status = status
        self.name = name
        self.description = description
        self.category = category
        self.subcategory = subcategory
        self.userMail = userMail
        self.userName = userName
        self.userSurname = userSurname
        self.userPhoto = photo
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInt64(forKey: "id")
        status = coder.decodeInteger(forKey: "status")
        name = coder.decodeObject(forKey: "name") as! String
        description = coder.decodeObject(forKey: "description") as! String
        category = coder.decodeInteger(forKey: "category")
        subcategory = coder.decodeInteger(forKey: "subcategory")
        userMail = coder.decodeObject(forKey: "userMail") as! String
        userName = coder.decodeObject(forKey: "userName") as? String
        userSurname = coder.decodeObject(forKey: "userSurname") as? String
        userPhoto = coder.decodeObject(forKey: "userPhoto") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(status, forKey: "status")
        coder.encode(name, forKey:"name")
        coder.encode(description, forKey: "description")
        coder.encode(category, forKey:"category")
        coder.encode(subcategory, forKey: "subcategory")
        coder.encode(userMail, forKey:"userMail")
        coder.encode(userName, forKey: "userName")
        coder.encode(userSurname, forKey: "userSurname")
        coder.encode(userPhoto, forKey: "userPhoto")
    }
    
    var toDict: [String: Any] {
        return ["id": id,
                "status": status,
                "name": name,
                "description": description,
                "category": category,
                "subcategory": subcategory,
                "userMail": userMail,
                "userName": userName as Any,
                "userSurname": userSurname as Any,
                "userPhoto": userPhoto as Any
        ]
    }
}
