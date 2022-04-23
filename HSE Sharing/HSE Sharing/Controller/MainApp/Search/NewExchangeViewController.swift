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
    var skill: Skill!
    var transaction: Transaction!
    var mySkills: [Skill]!
    var isEditingTransaction: Bool = false
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
        if isEditingTransaction {
            editTransaction()
        } else {
            createTransaction()
        }
    }
    
    private func editTransaction() {
        
    }
    
    private func createTransaction() {
        Api.shared.getUserByEmail(email: skill.userMail) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    if let user = user {
                        self.createTransactionWithUser(user: user)
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.showFailAlert()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func createTransactionWithUser(user: User) {
        let transaction = Transaction(id: 1, skill1: skill.name, skill2: mySkillTextField.text!, description: messageTextView.text ?? "", senderMail: CurrentUser.user.mail!, receiverMail: skill.userMail, whoWantMail: skill.status == 1 ? CurrentUser.user.mail! : skill.userMail, status:  skill.status == 1 ? 2 : 1, users: [CurrentUser.user, user])
        
        Api.shared.createTransaction(transaction: transaction) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "unwindToSearch", sender: nil)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureActivityIndicator()
        exchangeButton.isEnabled = false
        mySkillPickerView.delegate = self
        mySkillPickerView.dataSource = self
        mySkillTextField.inputView = mySkillPickerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageTextView.layer.cornerRadius = 10
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        photoOfAuthorImageView.layer.cornerRadius = photoOfAuthorImageView.frame.size.width / 2
        exchangeButton.makeButtonOval()
        if let curUserSkills = CurrentUser.user.skills, !curUserSkills.isEmpty {
            setSkills(skills: curUserSkills)
        } else {
            loadSkillsRequest()
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
    
    func setSkill(skill: Skill) {
        self.skill = skill
    }
    
    private func loadSkillsRequest() {
        activityIndicator.startAnimating()
        Api.shared.getSkillsOfSpecificUser(email: CurrentUser.user.mail!) { result in
            switch result {
            case .success(let skills):
                DispatchQueue.main.async {
                    CurrentUser.user.skills = skills
                    self.setSkills(skills: skills)
                    self.activityIndicator.stopAnimating()
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
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func setSkills(skills: [Skill]?) {
        self.mySkills = (skills?.filter { skill in
            return skill.status == (self.skill.status == 1 ? 2 : 1)
        })!
        
        if mySkills.isEmpty {
            showNoSkillsAlert()
        }
    }
    
    private func showNoSkillsAlert() {
        let successAlert = UIAlertController(title: "У Вас не добавлены соответствующие навыки", message: "Добавьте навыки в профиле.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.performSegue(withIdentifier: "unwindToSearch", sender: nil)
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
}
