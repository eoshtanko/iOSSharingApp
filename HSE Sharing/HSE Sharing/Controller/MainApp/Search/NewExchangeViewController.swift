//
//  NewExchangeViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 16.04.2022.
//

import Foundation
import UIKit

class NewExchangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var activityIndicator: UIActivityIndicatorView!
    var fromSearch = true
    var skill: Skill!
    var mySkills: [Skill]!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var withWhomTextLabel: UILabel!
    @IBOutlet weak var photoOfAuthorImageView: UIImageView!
    @IBOutlet weak var typeOfSkillTextLabel: UILabel!
    @IBOutlet weak var authorNameTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var mySkillLabel: UILabel!
    @IBOutlet weak var mySkillTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    let mySkillPickerView = UIPickerView()
    
    @IBOutlet weak var exchangeButton: UIButton!
    
    @IBAction func exchangeButtonPresssed(_ sender: Any) {
        createTransaction()
    }
    
    private func createTransaction() {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.getUserByEmail(email: skill.userMail) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if let user = user {
                        self.createTransactionWithUser(user: user)
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.showFailAlert()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func createTransactionWithUser(user: User) {
        let transaction = Transaction(id: 1, skill1: skill.name, skill2: mySkillTextField.text!, description: messageTextView.text ?? "", senderMail: CurrentUser.user.mail!, receiverMail: skill.userMail, whoWantMail: skill.status == 1 ? CurrentUser.user.mail! : skill.userMail, status:  0, users: [CurrentUser.user, user])
        
        Api.shared.createTransaction(transaction: transaction) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if self.fromSearch {
                        self.performSegue(withIdentifier: "unwindToSearch", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "unwindToForeignPersonalSkillList", sender: nil)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.showFailAlert()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureActivityIndicator()
        typeOfSkillTextLabel.text = skill.status == 1 ? EnterViewController.isEnglish ? "can" : "может" : EnterViewController.isEnglish ? "want" : "хочет"
        exchangeButton.isEnabled = false
        mySkillPickerView.delegate = self
        mySkillPickerView.dataSource = self
        mySkillTextField.inputView = mySkillPickerView
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoOfAuthorImageView.isUserInteractionEnabled = true
        photoOfAuthorImageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        nameTextLabel.isUserInteractionEnabled = true
        nameTextLabel.addGestureRecognizer(tapGestureRecognizer2)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageTextView.layer.cornerRadius = 10
        authorNameTextLabel.text = skill.userName ?? "No Name"
        if let imageBase64String = skill.userPhoto {
            let imageData = Data(base64Encoded: imageBase64String)
            photoOfAuthorImageView.image = UIImage(data: imageData!)
        } else {
            photoOfAuthorImageView.image = UIImage(named: "crowsHoldingWings")
        }
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        photoOfAuthorImageView.layer.cornerRadius = photoOfAuthorImageView.frame.size.width / 2
        exchangeButton.makeButtonOval()
            loadSkillsRequest()
        setLanguage()
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    func setSkill(skill: Skill) {
        self.skill = skill
    }
    
    private func loadSkillsRequest() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.getSkillsOfSpecificUser(email: CurrentUser.user.mail!) { result in
            switch result {
            case .success(let skills):
                DispatchQueue.main.async {
                    CurrentUser.user.skills = skills
                    self.setSkills(skills: skills)
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.showFailAlert()
                }
            }
        }
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
            Api.shared.getUserByEmail(email: self.skill.userMail) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.navigationItem.title = ""
                        let storyboard = UIStoryboard(name: "ForeignProfile", bundle: nil)
                        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ForeignProfile") as! ForeignProfileViewController
                        profileViewController.setUser(user: user!)
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.showFailAlert()
                    }
                }
            }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: (EnterViewController.isEnglish ? "Network error" : "Ошибка сети"), message: (EnterViewController.isEnglish ? "Check the internet." : "Проверьте интернет."), preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func setSkills(skills: [Skill]?) {
        self.mySkills = (skills?.filter { skill in
            return skill.status == self.skill.status
        })!
        
        if mySkills.isEmpty {
            showNoSkillsAlert()
        }
    }
    
    private func showNoSkillsAlert() {
        let successAlert = UIAlertController(title: EnterViewController.isEnglish ? "You have not added the appropriate skills" : "У Вас не добавлены соответствующие навыки", message: EnterViewController.isEnglish ? "Add skills to your profile." : "Добавьте навыки в профиле.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            if self.fromSearch {
                self.performSegue(withIdentifier: "unwindToSearch", sender: nil)
            } else {
                self.performSegue(withIdentifier: "unwindToForeignPersonalSkillList", sender: nil)
            }
        })
        present(successAlert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        mySkills.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return mySkills[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mySkillTextField.text =  mySkills[row].name
        mySkillTextField.resignFirstResponder()
        exchangeButton.isEnabled = true
    }
    
    private func setLanguage() {
        titleTextLabel.text = EnterViewController.isEnglish ? "Exchange" : "Обмен"
        withWhomTextLabel.text = EnterViewController.isEnglish ? "With whom:" : "С кем:"
        nameLabel.text = EnterViewController.isEnglish ? "Skill:" : "Навык:"
        mySkillLabel.text = EnterViewController.isEnglish ? "My offer:" : "Мое предложение:"
        messageLabel.text = EnterViewController.isEnglish ? "Message:" : "Сообщение:"
        exchangeButton.setTitle(EnterViewController.isEnglish ? "Exchange" : "Обмен", for: .normal)
        descriptionLabel.text = EnterViewController.isEnglish ? "Description:" : "Описание:"
        mySkillTextField.placeholder = EnterViewController.isEnglish ? "Choose one of your skills" : "Выберите один из своих навыков"
    }
}
