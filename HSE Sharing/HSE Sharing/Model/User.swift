//
//  Profile.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class User: Codable, NSCoding {
    var mail: String?
    var confirmationCodeServer: Int?
    var confirmationCodeUser: Int?
    var password: String?
    var name: String?
    var surname: String?
    var birthDate: Date?
    var gender: Int?
    var studyingYearId: Int?
    var majorId: Int?
    var campusLocationId: Int?
    var dormitoryId: Int?
    var about: String?
    var contact: String?
    var photo: String?
    var transactions: [Transaction]?
    var skills: [Skill]?
    var feedbacks: [Feedback]?
    var gradesCount: Int?
    var gradesSum: Int?
    var averageGrade: Double?
    var isModer: Bool?
    
    init(mail: String?, confirmationCodeServer: Int?, confirmationCodeUser: Int?, password: String?, name: String?, surname: String?, birthDate: Date?, gender: Int?, studyingYearId: Int?, majorId: Int?, campusLocationId: Int?, dormitoryId: Int?, about: String?, contact: String?, photo: String?, transactions: [Transaction]?, skills: [Skill]?, feedbacks: [Feedback]?, gradesCount: Int?, gradesSum: Int?, averageGrade: Double?, isModer: Bool?) {
        self.mail = mail
        self.confirmationCodeServer = confirmationCodeServer
        self.confirmationCodeUser = confirmationCodeUser
        self.password = password
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.gender = gender
        self.studyingYearId = studyingYearId
        self.majorId = majorId
        self.campusLocationId = campusLocationId
        self.about = about
        self.dormitoryId = dormitoryId
        self.contact = contact
        self.photo = photo
        self.transactions = transactions
        self.skills = skills
        self.feedbacks = feedbacks
        self.gradesCount = gradesCount
        self.gradesSum = gradesSum
        self.averageGrade = averageGrade
        self.isModer = isModer
    }
    
    public required init?(coder: NSCoder) {
        mail = coder.decodeObject(forKey: "mail")  as? String
        confirmationCodeServer = coder.decodeInteger(forKey: "confirmationCodeServer")
        confirmationCodeUser = coder.decodeInteger(forKey: "confirmationCodeUser")
        password = coder.decodeObject(forKey: "password") as? String
        name = coder.decodeObject(forKey: "name") as? String
        surname = coder.decodeObject(forKey: "surname") as? String
        birthDate = coder.decodeObject(forKey: "birthDate") as? Date
        gender = coder.decodeInteger(forKey: "gender")
        studyingYearId = coder.decodeInteger(forKey: "studyingYearId")
        majorId = coder.decodeInteger(forKey: "majorId")
        campusLocationId = coder.decodeInteger(forKey: "campusLocationId")
        dormitoryId = coder.decodeInteger(forKey: "dormitoryId")
        contact = coder.decodeObject(forKey: "contact") as? String
        about = coder.decodeObject(forKey: "about") as? String
        photo = coder.decodeObject(forKey: "photo") as? String
        transactions = coder.decodeObject(forKey: "transactions") as? [Transaction]
        skills = coder.decodeObject(forKey: "skills") as? [Skill]
        feedbacks = coder.decodeObject(forKey: "feedbacks") as? [Feedback]
        gradesCount = coder.decodeInteger(forKey: "gradesCount")
        gradesSum = coder.decodeInteger(forKey: "gradesSum")
        averageGrade = coder.decodeDouble(forKey: "averageGrade")
        isModer = coder.decodeBool(forKey: "isModer")
    }
}

extension User {
    
    var toDictInitial: [String: Any] {
        return ["mail": mail ?? ""]
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(mail, forKey:"mail")
        coder.encode(confirmationCodeServer, forKey: "confirmationCodeServer")
        coder.encode(confirmationCodeUser, forKey:"confirmationCodeUser")
        coder.encode(password, forKey: "password")
        coder.encode(name, forKey: "name")
        coder.encode(surname, forKey: "surname")
        coder.encode(birthDate, forKey:"birthDate")
        coder.encode(gender, forKey:"gender")
        coder.encode(studyingYearId, forKey:"studyingYearId")
        coder.encode(majorId, forKey: "majorId")
        coder.encode(campusLocationId, forKey:"campusLocationId")
        coder.encode(dormitoryId, forKey: "dormitoryId")
        coder.encode(contact, forKey: "contact")
        coder.encode(about, forKey: "about")
        coder.encode(photo, forKey: "photo")
        coder.encode(transactions, forKey:"transactions")
        coder.encode(skills, forKey:"skills")
        coder.encode(feedbacks, forKey:"feedbacks")
        coder.encode(gradesCount, forKey: "gradesCount")
        coder.encode(gradesSum, forKey: "gradesSum")
        coder.encode(averageGrade, forKey: "averageGrade")
        coder.encode(isModer, forKey:"isModer")
    }
    
    var toDict: [String: Any] {
        return ["mail": mail!,
                "confirmationCodeServer": confirmationCodeServer!,
                "confirmationCodeUser": confirmationCodeUser!,
                "password": password!,
                "name": name!,
                "surname": surname!,
                "birthDate": Formatter.iso8601.string(from: birthDate!),
                "gender": gender!,
                "studyingYearId": studyingYearId!,
                "majorId": majorId!,
                "campusLocationId": campusLocationId!,
                "dormitoryId": dormitoryId!,
                "about": about!,
                "contact": contact as Any,
                "photo": photo as Any,
                "transactions": getDictTransactions(),
                "skills": getDictSkills(),
                "feedbacks": getDictFeedbacks(),
                "gradesCount": gradesCount!,
                "gradesSum": gradesSum!,
                "averageGrade": averageGrade!,
                "isModer": isModer!
        ]
    }
    
    func getDictFeedbacks() -> [[String: Any]] {
        var dict: [[String: Any]] = []
        for feedback in feedbacks! {
            dict.append(feedback.toDict)
        }
        return dict
    }
    
    func getDictSkills() -> [[String: Any]] {
        var dict: [[String: Any]] = []
        for skill in skills! {
            dict.append(skill.toDict)
        }
        return dict
    }

    func getDictTransactions() -> [[String: Any]] {
        var dict: [[String: Any]] = []
        for transaction in transactions! {
            dict.append(transaction.toDict)
        }
        return dict
    }
}

struct CurrentUser {
    static let formatter = DateFormatter()
    static var user: User!
}
