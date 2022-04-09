//
//  EnterViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class EnterViewController : UIViewController {
    
    static var isEnglish = false
    
    private var emailIsValid: Bool = true
    private var passwordIsValid: Bool = true
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterButtonAction(_ sender: Any) {
        clearTextFields()
    }
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBAction func registrationButtonPressed(_ sender: Any) {
        clearTextFields()
    }
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBAction func recoveryButtonPressed(_ sender: Any) {
        clearTextFields()
    }
    
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        EnterViewController.isEnglish = !EnterViewController.isEnglish
        translateProfileView(EnterViewController.isEnglish)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    private func configureButtons() {
        enterButton.makeButtonOval()
        registrationButton.makeButtonOval()
        recoverPasswordButton.makeButtonOval()
    }
    
    private func configureTextFields() {
        configureTextFieldsDelegate(textField: emailTextField)
        emailTextField.tag = 1
        configureTextFieldsDelegate(textField: passwordTextField)
        passwordTextField.tag = 2
    }
    
    private func configureTextFieldsDelegate(textField: UITextField) {
        textField.delegate = self
    }
    
    private func clearTextFields() {
        self.view.endEditing(true)
        emailTextField.text = String()
        passwordTextField.text = String()
        emailTextField.changeColorOfBorder(isValid: true)
        passwordTextField.changeColorOfBorder(isValid: true)
    }
}

extension EnterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            emailIsValid = textField.text?.isEmailValid() ?? false
        case 2:
            passwordIsValid = textField.text?.isPasswordValid() ?? false
        default:
            return
        }
        changeValidEditingStatus()
    }
    
    func changeValidEditingStatus() {
        emailTextField.changeColorOfBorder(isValid: emailIsValid)
        passwordTextField.changeColorOfBorder(isValid: passwordIsValid)
        enterButton.isEnabled = emailIsValid && passwordIsValid
    }
}

extension EnterViewController {
    
    private func translateProfileView(_ isEnglish: Bool) {
        if isEnglish {
            changeLanguageButton.setTitle("🇷🇺", for: .normal)
        } else {
            changeLanguageButton.setTitle("🇬🇧", for: .normal)
        }
    }
}
