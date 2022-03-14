//
//  Exchange.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

struct Transaction {
    var id: UInt 
    var skill1: String
    var skill2: String
    var description: String
    var userName: String
    var userPhoto: UIImage
    // Статус: 0 - отправлен, 1 - подтвержден (активен), 2 - завершен
    var status: Int
}
