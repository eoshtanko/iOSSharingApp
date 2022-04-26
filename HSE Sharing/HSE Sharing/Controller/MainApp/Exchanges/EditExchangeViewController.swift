//
//  EditExchangeViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.04.2022.
//

import Foundation
import UIKit

class EditExchangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var activityIndicator: UIActivityIndicatorView!
    var transaction: Transaction!
    var mySkills: [Skill]?
    var user: User?
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var withWhomTextLabel: UILabel!
    @IBOutlet weak var photoOfAuthorImageView: UIImageView!
    @IBOutlet weak var typeOfSkillTextLabel: UILabel!
    @IBOutlet weak var authorNameTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var mySkillLabel: UILabel!
    @IBOutlet weak var mySkillTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    let mySkillPickerView = UIPickerView()
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonPresssed(_ sender: Any) {
        if let user = user {
            editTransactionWithUser(user: user)
        }
    }
    
    private func loadUser() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.getUserByEmail(email: transaction.receiverMail) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    self.authorNameTextLabel.text = user?.name ?? "No Name"
                    if let imageBase64String = user?.photo {
                        let imageData = Data(base64Encoded: imageBase64String)
                        self.photoOfAuthorImageView.image = UIImage(data: imageData!)
                    } else {
                        self.photoOfAuthorImageView.image = UIImage(named: "crowsHoldingWings")
                    }
                    self.loadSkillsRequest()
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
        Api.shared.getUserByEmail(email: self.transaction.receiverMail) { result in
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
    
    private func editTransactionWithUser(user: User) {
        let transaction = Transaction(id: transaction.id, skill1: transaction.skill1, skill2: mySkillTextField.text!, description: messageTextView.text ?? "", senderMail: transaction.senderMail, receiverMail: transaction.receiverMail, whoWantMail: transaction.whoWantMail, status: 0, users: transaction.users)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.editTransaction(transaction: transaction) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.performSegue(withIdentifier: "unwindOutcomingExchanges", sender: nil)
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
        loadUser()
        saveButton.isEnabled = false
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
        authorNameTextLabel.text = user?.name ?? "No Name"
        if let imageBase64String = user?.photo {
            let imageData = Data(base64Encoded: imageBase64String)
            photoOfAuthorImageView.image = UIImage(data: imageData!)
        } else {
            photoOfAuthorImageView.image = UIImage(named: "crowsHoldingWings")
        }
        nameTextLabel.text = transaction.skill2
        messageTextView.text = transaction.description
        photoOfAuthorImageView.layer.cornerRadius = photoOfAuthorImageView.frame.size.width / 2
        saveButton.makeButtonOval()
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    func setExchange(transaction: Transaction) {
        self.transaction = transaction
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
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func setSkills(skills: [Skill]?) {
        self.mySkills = (skills?.filter { skill in
            return skill.status == (self.transaction.whoWantMail == CurrentUser.user.mail ? 1 : 2)
        })!
        
        if mySkills == nil || mySkills!.isEmpty {
            showNoSkillsAlert()
        }
    }
    
    private func showNoSkillsAlert() {
        let successAlert = UIAlertController(title: "У Вас не добавлены соответствующие навыки", message: "Добавьте навыки в профиле.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.performSegue(withIdentifier: "unwindOutcomingExchanges", sender: nil)
        })
        present(successAlert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        mySkills?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return mySkills?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mySkillTextField.text =  mySkills?[row].name
        mySkillTextField.resignFirstResponder()
        saveButton.isEnabled = true
    }
}

