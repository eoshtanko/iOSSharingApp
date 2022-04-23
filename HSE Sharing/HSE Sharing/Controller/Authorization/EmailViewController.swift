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
    
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var goNextButton: UIButton!
    @IBAction func goNextButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        makeRequest()
    }
    
    private func makeRequest() {
        let mail: String = emailTextField.text!
        Api.shared.getUserByEmail(email: mail) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlreadyExistAlert()
                    self.clearTextFields()
                }
            case .failure(_):
                self.createNewUser(mail)
            }
        }
    }
    
    private func createNewUser(_ mail: String) {
        Api.shared.createUser(email: mail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    CurrentUser.user = user
                    Api.shared.startMessaging()
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "toCodeScreen", sender: nil)
                    self.clearTextFields()
                case .failure(_):
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goNextButton.isEnabled = false
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
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func showAlreadyExistAlert() {
        let successAlert = UIAlertController(title: "Данный пользователь уже зарегистрирован", message: nil, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.performSegue(withIdentifier: "unwindToEnter", sender: nil)
        })
        present(successAlert, animated: true, completion: nil)
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
