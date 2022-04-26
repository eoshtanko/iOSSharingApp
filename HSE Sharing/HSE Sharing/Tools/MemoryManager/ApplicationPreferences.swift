//
//  ApplicationPreferences.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation

class ApplicationPreferences: NSObject, Decodable, NSCoding {
    
    var isEnglish: Bool
    
    init(isEnglish: Bool) {
        self.isEnglish = isEnglish
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(isEnglish, forKey:"isEnglish")
    }
    
    required init?(coder: NSCoder) {
        isEnglish = coder.decodeBool(forKey: "isEnglish")
    }
}
