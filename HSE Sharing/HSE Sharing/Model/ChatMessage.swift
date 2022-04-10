//
//  ChatMessage.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import Foundation

class Message: Codable {
    
    let text: String
    let sendTime: Date
    let id: Int64
    let senderMail: String
    let receiverMail: String
    let isRead: Bool
    
    init(text: String, sendTime: Date, id: Int64, senderMail: String, receiverMail: String, isRead: Bool) {
        self.text = text
        self.sendTime = sendTime
        self.id = id
        self.senderMail = senderMail
        self.receiverMail = receiverMail
        self.isRead = isRead
    }
}

//extension ChatMessage: Comparable {
//
//  static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
//      return lhs.created < rhs.created
//  }
//}
