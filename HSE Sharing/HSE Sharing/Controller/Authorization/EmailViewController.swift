//
//  EmailViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class EmailViewController : UIViewController {
    
    private var emailIsValid: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var goNextButton: UIButton!
    @IBAction func goNextButtonAction(_ sender: Any) {
        clearTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    private func configureButtons() {
        goNextButton.makeButtonOval()
    }
    
    private func configureTextFields() {
        emailTextField.delegate = self
    }
    
    private func clearTextFields() {
        self.view.endEditing(true)
        emailTextField.text = String()
        emailTextField.changeColorOfBorder(isValid: true)
    }
}

extension EmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailIsValid = textField.text?.isEmailValid() ?? false
        changeValidEditingStatus()
    }
    
    func changeValidEditingStatus() {
        emailTextField.changeColorOfBorder(isValid: emailIsValid)
        goNextButton.isEnabled = emailIsValid
    }
}
