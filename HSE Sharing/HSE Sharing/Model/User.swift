//
//  Profile.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

class User {
    var mail: String?
    var confirmationCodeServer: String?
    var confirmationCodeUser: String?
    var password: String?
    var name: String?
    var surname: String?
    var birthDate: Date?
    // 0 - male, 1- female
    var gender: Int?
    var studyingYearId: Int?
    var majorId: Int?
    var campusLocationId: Int?
    var dormitoryId: Int?
    var about: String?
    var contact: String?
    // TODO: bytes
    var photo: UIImage?
    var transactions: [Transaction]?
    var skills: [Skill]?
    var isModer: Bool?
    
    init(mail: String?, confirmationCodeServer: String?, confirmationCodeUser: String?, password: String?, name: String?, surname: String?, birthDate: Date?, gender: Int?, studyingYearId: Int?, majorId: Int?, campusLocationId: Int?, dormitoryId: Int?, about: String?, contact: String?, photo: UIImage?, transactions: [Transaction]?, skills: [Skill]?, isModer: Bool?) {
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
        self.dormitoryId = dormitoryId
        self.contact = contact
        self.photo = photo
        self.transactions = transactions
        self.skills = skills
        self.isModer = isModer
    }
}

struct CurrentUser {
    static let formatter = DateFormatter()
    static let user = Api.getCurrentUser()
}
