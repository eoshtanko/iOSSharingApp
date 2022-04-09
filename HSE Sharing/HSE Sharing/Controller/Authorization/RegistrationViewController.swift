//
//  RegistrationViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class RegistrationViewController : UIViewController {
    
    private var nameIsValid: Bool = true
    private var surnameIsValid: Bool = true
    private var passwordIsValid: Bool = true
    private var repeatPasswordIsValid: Bool = true
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBAction func registrationButtonPressed(_ sender: Any) {
        clearTextFields()
        goToMainAppRootTabBarVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    private func goToMainAppRootTabBarVC() {
        let mainAppRootTabBarVC = RootTabBarViewController()
        mainAppRootTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppRootTabBarVC, animated: true)
    }
    
    private func configureButtons() {
        registrationButton.makeButtonOval()
    }
    
    private func configureTextFields() {
        configureTextFieldsDelegate(textField: nameTextFiled)
        nameTextFiled.tag = 1
        configureTextFieldsDelegate(textField: surnameTextField)
        surnameTextField.tag = 2
        configureTextFieldsDelegate(textField: passwordTextField)
        passwordTextField.tag = 3
        configureTextFieldsDelegate(textField: repeatPasswordTextField)
        repeatPasswordTextField.tag = 4
    }
    
    private func configureTextFieldsDelegate(textField: UITextField) {
        textField.delegate = self
    }
    
    private func clearTextFields() {
        self.view.endEditing(true)
        nameTextFiled.text = String()
        surnameTextField.text = String()
        passwordTextField.text = String()
        repeatPasswordTextField.text = String()
        nameTextFiled.changeColorOfBorder(isValid: true)
        surnameTextField.changeColorOfBorder(isValid: true)
        passwordTextField.changeColorOfBorder(isValid: true)
        repeatPasswordTextField.changeColorOfBorder(isValid: true)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            nameIsValid = textField.text?.isNameOrSurnameValid() ?? false
        case 2:
            surnameIsValid = textField.text?.isNameOrSurnameValid() ?? false
        case 3:
            passwordIsValid = textField.text?.isPasswordValid() ?? false
        case 4:
            repeatPasswordIsValid = isRepeatNewPasswordIsValid(textField.text ?? "")
        default:
            return
        }
        changeValidEditingStatus()
    }
    
    func isRepeatNewPasswordIsValid(_ repeatNewPassword: String) -> Bool {
        return !passwordIsValid || passwordTextField.text == repeatPasswordTextField.text
    }
    
    func changeValidEditingStatus() {
        nameTextFiled.changeColorOfBorder(isValid: nameIsValid)
        surnameTextField.changeColorOfBorder(isValid: surnameIsValid)
        passwordTextField.changeColorOfBorder(isValid: passwordIsValid)
        repeatPasswordTextField.changeColorOfBorder(isValid: repeatPasswordIsValid)
        registrationButton.isEnabled = nameIsValid && surnameIsValid && passwordIsValid && repeatPasswordIsValid
    }
}
