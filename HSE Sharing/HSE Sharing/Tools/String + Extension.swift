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
        return self.count >= min && self.count <= max
    }
    
    func endWith(_ str: String) -> Bool {
        return self.reversed().starts(with: str.reversed())
    }
    
    func isSocialNetworkValid() -> Bool {
        return self.starts(with: "vk.com/") || self.starts(with: "t.me/")
    }
    
    func isEmailValid() -> Bool {
        return self.endWith("@edu.hse.ru") && self.count > 11
    }
    
    func isNameOrSurnameValid() -> Bool {
        return self.сontainsCharactersInTheRange(min: 2, max: 40) && self.containsOnlyLetters()
    }
    
    func isPasswordValid() -> Bool {
        return self.сontainsCharactersInTheRange(min: 6, max: 40)
    }
    
    func isCodeValid() -> Bool {
        return self.count == 4
    }
    
    func isNameOfSkillValid() -> Bool {
        return self.count > 0 && self.count <= 50
    }
}
