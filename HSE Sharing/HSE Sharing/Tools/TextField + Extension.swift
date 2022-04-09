//
//  TextField + Extension.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

extension UITextField {
    
    func changeColorOfBorder(isValid: Bool) {
        if isValid {
            self.layer.borderWidth = 0.2
            self.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.layer.borderWidth = 1
            self.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
}
