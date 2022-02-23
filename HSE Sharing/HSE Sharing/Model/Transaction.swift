//
//  Exchange.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import Foundation

struct Transaction {
    var id: UInt 
    var skill1: String
    var skill2: String
    var description: String
    var senderMail: String
    var receiverMail: String
    var whoWantMail: String
    // Статус: 0 - отправлен, 1 - подтвержден (активен), 2 - завершен
    var status: Int
}
