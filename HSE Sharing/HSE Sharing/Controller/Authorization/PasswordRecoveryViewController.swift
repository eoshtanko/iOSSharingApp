//
//  PasswordRecoveryViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class PasswordRecoveryViewController : UIViewController {
    
    private var emailIsValid: Bool = true
    
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var recoveryButton: UIButton!
    @IBAction func recoveryButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        makeRequest()
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
        recoveryButton.isEnabled = false
    }
    
    private func makeRequest() {
        self.view.isUserInteractionEnabled = false
        Api.shared.recoveryUsersPassword(email: emailTextField.text!) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.clearTextFields()
                    self.goBack()
                }
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if apiError as! ApiError == ApiError.noSuchData {
                        self.noSuchUserAlert()
                    } else {
                        self.showFailAlert()
                    }
                }
            }
        }
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
    
    private func noSuchUserAlert() {
        let successAlert = UIAlertController(title: "Данный пользователь не зарегистрирован", message: nil, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func goBack() {
        self.performSegue(withIdentifier: "unwindToEnterFromRecovery", sender: nil)
    }
    
    private func configureButtons() {
        recoveryButton.makeButtonOval()
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

extension PasswordRecoveryViewController: UITextFieldDelegate {
    
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
        recoveryButton.isEnabled = emailIsValid
    }
}
