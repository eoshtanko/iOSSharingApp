//
//  ChangePasswordViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 03.04.2022.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {
    
    private var user: User?
    
    private var newPasswordValid: Bool = false
    private var repeatNewPasswordIsValid: Bool = false
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var repeatNewPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        makeRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureLanguage()
        saveButton.makeButtonOval()
        newPasswordTextField.tag = 1
        newPasswordTextField.delegate = self
        repeatNewPasswordTextField.tag = 2
        repeatNewPasswordTextField.delegate = self
    }
    
    func setUser(user: User?) {
        self.user = user
    }
    
    private func makeRequest() {
        Api.shared.editUser(email: self.user!.mail!, user: self.user!) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Попробовать еще раз или отменить изменения?", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "Еще раз", style: UIAlertAction.Style.default) { _ in
            self.makeRequest()
        })
        successAlert.addAction(UIAlertAction(title: "Отмена изменения", style: UIAlertAction.Style.default) { _ in
            self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
        })
        present(successAlert, animated: true, completion: nil)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    private func configureLanguage() {
        titleTextLabel.text = EnterViewController.isEnglish ? "Password change" : "Смена пароля"
        newPasswordLabel.text = EnterViewController.isEnglish ? "New password" : "Новый пароль"
        repeatNewPasswordLabel.text = EnterViewController.isEnglish ? "Repeat the password" : "Повторите пароль"
        newPasswordTextField.placeholder = EnterViewController.isEnglish ? "Enter a new password" : "Введите новый пароль"
        repeatNewPasswordTextField.placeholder = EnterViewController.isEnglish ? "Re-enter the new password" : "Повторите ввод нового пароля"
        saveButton.setTitle(EnterViewController.isEnglish ? "Save" : "Сохранить", for: .normal)
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
            newPasswordValid = textField.text?.isPasswordValid() ?? false
            repeatNewPasswordIsValid = isRepeatNewPasswordIsValid(textField.text ?? "")
        case 2:
            repeatNewPasswordIsValid = isRepeatNewPasswordIsValid(textField.text ?? "")
        default:
            return
        }
        changeValidEditingStatus()
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
