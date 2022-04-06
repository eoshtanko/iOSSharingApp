//
//  String + Extension.swift
//  HSE Sharing
//
//  Created by Екатерина on 06.04.2022.
//

import Foundation

extension String {
    func containsOnlyLetters() -> Bool {
        for chr in self {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr >= "а" && chr <= "я") && !(chr >= "А" && chr <= "Я")) {
             return false
          }
       }
       return true
    }
    
    func сontainsCharactersInTheRange(min: Int, max: Int) -> Bool {
        return self.count > min && self.count < max
    }
    
    func endWith(_ str: String) -> Bool {
        return self.reversed().starts(with: str.reversed())
    }
}
