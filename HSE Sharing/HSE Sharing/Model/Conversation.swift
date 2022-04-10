//
//  Conversation.swift
//  HSE Sharing
//
//  Created by Екатерина on 04.04.2022.
//

import UIKit

class Conversation: Codable, NSCoding {

    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let image: Data?
    
    init(name: String) {
        self.name = name
        self.identifier = "111"
        self.lastMessage = nil
        self.lastActivity = nil
        self.image = nil
    }
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, image: Data) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.image = image
    }
    
    public required init?(coder: NSCoder) {
        identifier = coder.decodeObject(forKey: "identifier") as! String
        name = coder.decodeObject(forKey: "name") as! String
        lastMessage = coder.decodeObject(forKey: "lastMessage") as? String
        lastActivity = coder.decodeObject(forKey: "lastActivity") as? Date
        image = coder.decodeObject(forKey: "image") as? Data
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey:"identifier")
        coder.encode(name, forKey: "name")
        coder.encode(lastMessage, forKey:"lastMessage")
        coder.encode(lastActivity, forKey: "lastActivity")
        coder.encode(image, forKey:"image")
    }
}

extension Conversation {
    
    var toDict: [String: Any] {
        return ["name": name, "lastMessage": "", "lastActivity": Date()]
    }
}

extension Conversation: Comparable {
    
  static func == (lhs: Conversation, rhs: Conversation) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  static func < (lhs: Conversation, rhs: Conversation) -> Bool {
      return lhs.lastActivity ?? Date() > rhs.lastActivity ?? Date()
  }
}
