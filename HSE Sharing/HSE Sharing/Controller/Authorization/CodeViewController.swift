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
        if let realCode = CurrentUser.user.confirmationCodeServer {
            if "\(realCode)" == textField.text! {
                clearTextFields()
                CurrentUser.user.confirmationCodeUser = CurrentUser.user.confirmationCodeServer
                self.performSegue(withIdentifier: "goToRegistration", sender: nil)
            } else {
                showFailAlert()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
        titleLabel.text = EnterViewController.isEnglish ? "Code" : "Код"
        subTitleLabel.text = EnterViewController.isEnglish ? "A confirmation code has been sent to your email. Enter it." : "Вам на почту был отправлен код подверждения. Введите его."
        goNextButton.setTitle(EnterViewController.isEnglish ? "Next" : "Далее", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(CurrentUser.user.confirmationCodeServer)
        goNextButton.isEnabled = false
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: EnterViewController.isEnglish ? "Invalid code" : "Неверный код" , message: EnterViewController.isEnglish ?  "Try again. The code must be in your mail." : "Попробуйте еще раз. Код должен быть у Вас на почте.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func configureButtons() {
        goNextButton.makeButtonOval()
    }
    
    private func configureTextFields() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(codeTextFieldDidChange), for: .editingChanged)
    }
    
    @objc private func codeTextFieldDidChange() {
        codeIsValid = textField.text?.isCodeValid() ?? false
        changeValidEditingStatus()
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
