//
//  Button + Extension.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

extension UIButton {
    func makeButtonOval() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
