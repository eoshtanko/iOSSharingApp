//
//  Profile.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import Foundation

struct User {
    var mail: String
    var confirmationCodeServer: String
    var confirmationCodeUser: String
    var password: String
    var name: String
    var surname: String
    var birthDate: Date
    // 0 - male, 1- female
    var gender: Int
    var studyingYearId: Int
    var majorId: Int
    var campusLocationId: Int
    var dormitoryId: Int
    var about: String
    var contact: String
    // TODO: bytes
    var photo: [Int]
    var transactions: [Transaction]
    var skills: [Skill]
}
