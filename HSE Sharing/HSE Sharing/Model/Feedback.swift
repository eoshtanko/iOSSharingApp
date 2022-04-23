//
//  Feedback.swift
//  HSE Sharing
//
//  Created by Екатерина on 03.04.2022.
//

import Foundation

class Feedback: Codable, NSCoding {
    let id: Int64
    let grade: Int
    let comment: String
    let senderMail: String
    let receiverMail: String
    
    init(id: Int64, grade: Int, comment: String, senderMail: String, receiverMail: String) {
        self.id = id
        self.grade = grade
        self.comment = comment
        self.senderMail = senderMail
        self.receiverMail = receiverMail
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInt64(forKey: "id")
        grade = coder.decodeInteger(forKey: "grade")
        comment = coder.decodeObject(forKey: "comment") as! String
        senderMail = coder.decodeObject(forKey: "senderMail") as! String
        receiverMail = coder.decodeObject(forKey: "receiverMail") as! String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(grade, forKey: "grade")
        coder.encode(comment, forKey:"comment")
        coder.encode(senderMail, forKey: "senderMail")
        coder.encode(receiverMail, forKey:"receiverMail")
    }
    
    var toDict: [String: Any] {
        return [
            "grade": grade,
            "comment": comment,
            "senderMail": senderMail,
            "receiverMail": receiverMail
        ]
    }
}
