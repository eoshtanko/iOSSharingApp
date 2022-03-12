//
//  ChatMessage.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import Foundation

class ChatMessage {
    var text: String?
    var isIncoming: Bool
    var date: Date?
    
    init(text: String?, isIncoming: Bool, date: Date?) {
        self.text = text
        self.isIncoming = isIncoming
        self.date = date
    }
}
