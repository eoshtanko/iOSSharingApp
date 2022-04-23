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
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var emailIsValid: Bool = true
    private var passwordIsValid: Bool = true
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func unwindToEnterViewController(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        makeRequest()
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
//        Api.shared.sendMessage(mail: "2@edu.hse.ru", message: Message(id: 1, sendTime: "23.02.2001", text: "Hi!!!",  senderMail: "1@edu.hse.ru", receiverMail: "2@edu.hse.ru"))
        EnterViewController.isEnglish = !EnterViewController.isEnglish
        translateProfileView(EnterViewController.isEnglish)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    private func makeRequest() {
        Api.shared.getUserByEmail(email: emailTextField.text!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if user?.password != self.passwordTextField.text! {
                        self.wrongPasswordAlert()
                    } else {
                        CurrentUser.user = user
                        Api.shared.startMessaging()
                        self.clearTextFields()
                        self.goToMainAppRootTabBarVC()
                    }
                }
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
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
    
    private func wrongPasswordAlert() {
        let successAlert = UIAlertController(title: "Неверный пароль.", message: nil, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func noSuchUserAlert() {
        let successAlert = UIAlertController(title: "Данный пользователь не зарегистрирован", message: nil, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
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
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
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
