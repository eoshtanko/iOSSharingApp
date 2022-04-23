//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Екатерина on 09.03.2022.
//

import Foundation

class Message: Codable, NSCoding {
    
    let id: Int64
    let sendTime: String
    let text: String
    let senderMail: String
    let receiverMail: String
    
    init(id: Int64, sendTime: String, text: String, senderMail: String, receiverMail: String) {
        self.id = id
        self.sendTime = sendTime
        self.text = text
        self.senderMail = senderMail
        self.receiverMail = receiverMail
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInt64(forKey: "id")
        sendTime = coder.decodeObject(forKey: "sendTime") as! String
        text = coder.decodeObject(forKey: "text") as! String
        senderMail = coder.decodeObject(forKey: "senderMail") as! String
        receiverMail = coder.decodeObject(forKey: "receiverMail") as! String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(sendTime, forKey: "sendTime")
        coder.encode(text, forKey:"text")
        coder.encode(senderMail, forKey: "senderMail")
        coder.encode(receiverMail, forKey:"receiverMail")
    }
    
    var toDict: [String: Any] {
        return ["text": text,
                "sendTime": sendTime,
                "id": id,
                "senderMail": senderMail,
                "receiverMail": receiverMail]
    }
}
