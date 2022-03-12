//
//  Conversation.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class Conversation {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    // Ну как же можно без картинки? Без картиники нехорошо.
    var image: UIImage?
    
    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool, image: UIImage?) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.image = image
    }
}
