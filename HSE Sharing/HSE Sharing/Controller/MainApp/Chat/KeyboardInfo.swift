//
//  KeyboardInfo.swift
//  HSE Sharing
//
//  Created by Екатерина on 22.04.2022.
//

import Foundation
import UIKit

struct KeyboardInfo {
    var frameBegin: CGRect?
    var frameEnd: CGRect?
}

extension KeyboardInfo {
    init?(_ notification: NSNotification) {
        guard notification.name == UIResponder.keyboardWillShowNotification ||
                notification.name == UIResponder.keyboardWillChangeFrameNotification else { return nil }
        if let userInfo = notification.userInfo {
            frameBegin = userInfo[UIWindow.keyboardFrameBeginUserInfoKey] as? CGRect
            frameEnd = userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect
        }
    }
}
