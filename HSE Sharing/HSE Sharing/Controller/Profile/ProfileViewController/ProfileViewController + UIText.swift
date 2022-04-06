//
//  ProfileViewController + UIText.swift
//  HSE Sharing
//
//  Created by Екатерина on 06.04.2022.
//

import UIKit

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // TODO: проваливаться в case
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            nameIsValid = isNameOrSurnameValid(textField.text ?? "")
        case 2:
            surnameIsValid = isNameOrSurnameValid(textField.text ?? "")
        case 3:
            emailIsValid = isEmailValid(textField.text ?? "")
        case 4:
            guard let socialNetwork = textField.text else {
                socialNetworkIsValid = true
                return
            }
            socialNetworkIsValid = isSocialNetworkValid(socialNetwork) || socialNetwork.isEmpty
        default:
            return
        }
        changeValidEditingStatus()
    }
    
    func isSocialNetworkValid(_ network: String) -> Bool {
        return network.starts(with: "vk.com/") || network.starts(with: "t.me/")
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return email.endWith("@edu.hse.ru")
    }
    
    func isNameOrSurnameValid(_ name: String) -> Bool {
        return name.сontainsCharactersInTheRange(min: 2, max: 40) && name.containsOnlyLetters()
    }
    
    func changeValidEditingStatus() {
        changeColorOfBorder(textField: nameTextFiled, isValid: nameIsValid)
        changeColorOfBorder(textField: surnameTextField, isValid: surnameIsValid)
        changeColorOfBorder(textField: emailTextField, isValid: emailIsValid)
        changeColorOfBorder(textField: socialNetworkTextField, isValid: socialNetworkIsValid)
        bottomButtom.isEnabled = nameIsValid && surnameIsValid && emailIsValid && socialNetworkIsValid
    }
    
    func changeColorOfBorder(textField: UITextField, isValid: Bool) {
        if isValid {
            textField.layer.borderWidth = 0.2
            textField.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Const.textViewPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
