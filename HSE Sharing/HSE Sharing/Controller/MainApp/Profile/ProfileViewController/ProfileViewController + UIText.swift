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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            nameIsValid = textField.text?.isNameOrSurnameValid() ?? false
            currentUser?.name = textField.text
        case 2:
            surnameIsValid = textField.text?.isNameOrSurnameValid() ?? false
            currentUser?.surname = textField.text
        case 3:
            emailIsValid = textField.text?.isEmailValid() ?? false
            currentUser?.mail = textField.text
        case 4:
            guard let socialNetwork = textField.text else {
                socialNetworkIsValid = true
                return
            }
            socialNetworkIsValid = socialNetwork.isSocialNetworkValid() || socialNetwork.isEmpty
            currentUser?.contact = textField.text
        default:
            return
        }
        changeValidEditingStatus()
    }
    
    func changeValidEditingStatus() {
        nameTextFiled.changeColorOfBorder(isValid: nameIsValid)
        surnameTextField.changeColorOfBorder(isValid: surnameIsValid)
        emailTextField.changeColorOfBorder(isValid: emailIsValid)
        socialNetworkTextField.changeColorOfBorder(isValid: socialNetworkIsValid)
        bottomButtom.isEnabled = nameIsValid && surnameIsValid && emailIsValid && socialNetworkIsValid
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
            textView.text = CurrentUser.user.mail == currentUser?.mail ? "Расскажите о себе :)" : "Нет информации"
            textView.textColor = UIColor.lightGray
        } else {
            currentUser?.about = textView.text
        }
    }
}
