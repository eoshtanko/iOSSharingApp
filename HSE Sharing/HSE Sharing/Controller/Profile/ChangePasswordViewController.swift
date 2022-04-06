//
//  ChangePasswordViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 03.04.2022.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {
    
    private var newPasswordValid: Bool = false
    private var repeatNewPasswordIsValid: Bool = false
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var repeatNewPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToProfile", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        makeButtonOval(button: saveButton)
        newPasswordTextField.tag = 1
        newPasswordTextField.delegate = self
        repeatNewPasswordTextField.tag = 2
        repeatNewPasswordTextField.delegate = self
    }
    
    private func makeButtonOval(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    private func configureLanguage() {
        titleTextLabel.text = ProfileViewController.isEnglish ? "Password change" : "Смена пароля"
        newPasswordLabel.text = ProfileViewController.isEnglish ? "New password" : "Новый пароль"
        repeatNewPasswordLabel.text = ProfileViewController.isEnglish ? "Repeat the password" : "Повторите пароль"
        newPasswordTextField.placeholder = ProfileViewController.isEnglish ? "Enter a new password" : "Введите новый пароль"
        repeatNewPasswordTextField.placeholder = ProfileViewController.isEnglish ? "Re-enter the new password" : "Повторите ввод нового пароля"
        saveButton.setTitle(ProfileViewController.isEnglish ? "Save" : "Сохранить", for: .normal)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // TODO: проваливаться в case
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            newPasswordValid = isNewPasswordValid(textField.text ?? "")
            repeatNewPasswordIsValid = isRepeatNewPasswordIsValid(textField.text ?? "")
        case 2:
            repeatNewPasswordIsValid = isRepeatNewPasswordIsValid(textField.text ?? "")
        default:
            return
        }
        changeValidEditingStatus()
    }
    
    func isNewPasswordValid(_ newPassword: String) -> Bool {
        return newPassword.сontainsCharactersInTheRange(min: 6, max: 40)
    }
    
    func isRepeatNewPasswordIsValid(_ repeatNewPassword: String) -> Bool {
        return !newPasswordValid || newPasswordTextField.text == repeatNewPasswordTextField.text
    }
    
    func changeValidEditingStatus() {
        saveButton.isEnabled = newPasswordValid && repeatNewPasswordIsValid
        changeColorOfBorder(textField: newPasswordTextField, isValid: newPasswordValid)
        changeColorOfBorder(textField: repeatNewPasswordTextField, isValid: repeatNewPasswordIsValid)
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
