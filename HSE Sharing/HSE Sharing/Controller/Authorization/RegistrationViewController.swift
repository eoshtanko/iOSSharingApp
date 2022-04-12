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
    
    private var activityIndicator: UIActivityIndicatorView!
    
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
        let user = getNewUser()
        makeRequest(user)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
    }
    
    private func makeRequest(_ user: User) {
        Api.shared.editUser(email: CurrentUser.user.mail!, user: user) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.clearTextFields()
                    self.goToMainAppRootTabBarVC()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
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
    
    private func goToMainAppRootTabBarVC() {
        let mainAppRootTabBarVC = RootTabBarViewController()
        mainAppRootTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppRootTabBarVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registrationButton.isEnabled = false
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
    
    private func getNewUser() -> User {
        return User(mail: CurrentUser.user.mail,
                    confirmationCodeServer: CurrentUser.user.confirmationCodeServer,
                    confirmationCodeUser: CurrentUser.user.confirmationCodeUser,
                    password: passwordTextField.text!,
                    name: nameTextFiled.text!,
                    surname: surnameTextField.text!,
                    birthDate: CurrentUser.user.birthDate,
                    gender: CurrentUser.user.gender,
                    studyingYearId: CurrentUser.user.studyingYearId,
                    majorId: CurrentUser.user.majorId,
                    campusLocationId: CurrentUser.user.campusLocationId,
                    dormitoryId: CurrentUser.user.dormitoryId,
                    about: CurrentUser.user.about,
                    contact: CurrentUser.user.contact,
                    photo: CurrentUser.user.photo,
                    transactions: CurrentUser.user.transactions,
                    skills: CurrentUser.user.skills,
                    feedbacks: CurrentUser.user.feedbacks,
                    gradesCount: CurrentUser.user.gradesCount,
                    gradesSum: CurrentUser.user.gradesSum,
                    averageGrade: CurrentUser.user.averageGrade,
                    isModer: CurrentUser.user.isModer)
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
