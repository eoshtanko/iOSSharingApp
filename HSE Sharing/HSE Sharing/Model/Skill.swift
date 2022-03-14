//
//  Skill.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

struct Skill {
    var id: UInt
    // Статус: 1 - могу, 2 - хочу
    var status: Int
    var name: String
    var description: String
    var category: Int
    var subcategory: Int
    var userName: String
    var userPhoto: UIImage
}
