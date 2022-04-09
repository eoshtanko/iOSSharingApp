//
//  CodeViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class CodeViewController : UIViewController {
    
    private var codeIsValid: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
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
        textField.delegate = self
    }
    
    private func clearTextFields() {
        self.view.endEditing(true)
        textField.text = String()
        textField.changeColorOfBorder(isValid: true)
    }
}

extension CodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        codeIsValid = textField.text?.isCodeValid() ?? false
        changeValidEditingStatus()
    }
    
    func changeValidEditingStatus() {
        textField.changeColorOfBorder(isValid: codeIsValid)
        goNextButton.isEnabled = codeIsValid
    }
}
