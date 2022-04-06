//
//  Conversation.swift
//  HSE Sharing
//
//  Created by Екатерина on 04.04.2022.
//

import UIKit

struct Conversation {

    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let image: UIImage?
    
    init(name: String) {
        self.name = name
        self.identifier = "111"
        self.lastMessage = nil
        self.lastActivity = nil
        self.image = nil
    }
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, image: UIImage) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.image = image
    }
    
//    init?(document: QueryDocumentSnapshot) {
//        let data = document.data()
//
//        guard let name = data["name"] as? String,
//              let lastMessage = data["lastMessage"] as? String,
//              let lastActivity = data["lastActivity"] as? Timestamp else {
//                  return nil
//              }
//
//        self.identifier = document.documentID
//        self.name = name
//        self.lastMessage = lastMessage
//        self.lastActivity = lastActivity.dateValue()
//    }
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
