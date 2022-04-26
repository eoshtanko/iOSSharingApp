//
//  EnterViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class EnterViewController : UIViewController {
    
    static var isEnglish = false {
        didSet {
            MemoryManager.instance.saveApplicationPreferences([ApplicationPreferences(isEnglish: isEnglish)])
        }
    }
    
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
        EnterViewController.isEnglish = !EnterViewController.isEnglish
        translate(EnterViewController.isEnglish)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureActivityIndicator()
        EnterViewController.isEnglish = getLanguageFromMemory()
        translate(EnterViewController.isEnglish)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = ""
        configureButtons()
        configureTextFields()
    }
    
    private func getLanguageFromMemory() -> Bool {
        let language = MemoryManager.instance.getApplicationPreferences()
        guard let language = language else {
            return false
        }
        if !language.isEmpty {
            print(language[0].isEnglish)
            return language[0].isEnglish
        } else {
            return false
        }
    }
    
    private func makeRequest() {
        self.view.isUserInteractionEnabled = false
        Api.shared.getUserByEmail(email: emailTextField.text!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
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
    
    private func wrongPasswordAlert() {
        let successAlert = UIAlertController(title: (EnterViewController.isEnglish ? "Wrong password" : "Неверный пароль."), message: nil, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func noSuchUserAlert() {
        let noSuchUserAlert = UIAlertController(title: (EnterViewController.isEnglish ? "This user is not registered" : "Данный пользователь не зарегистрирован"), message: nil, preferredStyle: UIAlertController.Style.alert)
        noSuchUserAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(noSuchUserAlert, animated: true, completion: nil)
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: (EnterViewController.isEnglish ? "Network error" : "Ошибка сети"), message: (EnterViewController.isEnglish ? "Check the internet." : "Проверьте интернет."), preferredStyle: UIAlertController.Style.alert)
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
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        emailTextField.tag = 1
        configureTextFieldsDelegate(textField: passwordTextField)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        passwordTextField.tag = 2
    }
    
    @objc private func emailTextFieldDidChange() {
        emailIsValid = emailTextField.text?.isEmailValid() ?? false
        changeValidEditingStatus()
    }
    
    @objc private func passwordTextFieldDidChange() {
        passwordIsValid = passwordTextField.text?.isPasswordValid() ?? false
        changeValidEditingStatus()
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
    
    private func translate(_ isEnglish: Bool) {
        if isEnglish {
            changeLanguageButton.setTitle("🇷🇺", for: .normal)
            passwordLabel.text = "Password"
            enterButton.setTitle("Enter", for: .normal)
            registrationButton.setTitle("Registration", for: .normal)
            recoverPasswordButton.setTitle("Password Recovery", for: .normal)
            emailTextField.placeholder = "Enter your edu.hse.ru email"
            passwordTextField.placeholder = "Enter the password"
        } else {
            changeLanguageButton.setTitle("🇬🇧", for: .normal)
            passwordLabel.text = "Пароль"
            enterButton.setTitle("Вход", for: .normal)
            registrationButton.setTitle("Регистрация", for: .normal)
            recoverPasswordButton.setTitle("Восстановление пароля", for: .normal)
            emailTextField.placeholder = "Введите почту edu.hse.ru"
            passwordTextField.placeholder = "Введите пароль"
        }
    }
}
