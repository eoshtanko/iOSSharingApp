//
//  Skill.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class Skill: Codable, NSCoding {
    var id: Int
    // Статус: 1 - могу, 2 - хочу
    var status: Int
    var name: String
    var description: String
    var category: Int
    var subcategory: Int
    var userName: String
    var userPhoto: Data
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInteger(forKey: "id")
        status = coder.decodeInteger(forKey: "status")
        name = coder.decodeObject(forKey: "name") as! String
        description = coder.decodeObject(forKey: "description") as! String
        category = coder.decodeInteger(forKey: "category")
        subcategory = coder.decodeInteger(forKey: "subcategory")
        userName = coder.decodeObject(forKey: "userName") as! String
        userPhoto = coder.decodeObject(forKey: "userPhoto") as! Data
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(status, forKey: "status")
        coder.encode(name, forKey:"name")
        coder.encode(description, forKey: "description")
        coder.encode(category, forKey:"category")
        coder.encode(subcategory, forKey: "subcategory")
        coder.encode(userName, forKey:"userName")
        coder.encode(userPhoto, forKey:"userPhoto")
    }
}
