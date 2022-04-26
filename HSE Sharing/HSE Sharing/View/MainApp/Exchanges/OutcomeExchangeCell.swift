//
//  OutcomeExchangeCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.04.2022.
//

import UIKit

class OutcomeExchangeCell: UITableViewCell {
    
    static let identifier = String(describing: OutcomeExchangeCell.self)
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var withWhomLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var whatReceive: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var whatGive: UILabel!
    @IBOutlet weak var giveLabel: UILabel!
    
    @IBAction func deleteAction(_ sender: Any) {
        delete?(transaction)
    }
    
    @IBAction func editAction(_ sender: Any) {
        edit?(transaction)
    }
    
    var user: User?
    var transaction: Transaction!
    var delete: ((Transaction) -> Void)?
    var edit: ((Transaction) -> Void)?
    var action: ((UITapGestureRecognizer, Transaction, User?) -> Void)!
    
    func configureCell(_ transaction: Transaction, delete: ((Transaction) -> Void)?, edit: ((Transaction) -> Void)?, _ action: @escaping ((UITapGestureRecognizer, Transaction, User?) -> Void)) {
        self.transaction = transaction
        self.action = action
        self.delete = delete
        self.edit = edit
        makeRequest(mail: transaction.senderMail == CurrentUser.user.mail ? transaction.receiverMail : transaction.senderMail)
        receiveLabel.text = transaction.skill1
        giveLabel.text = transaction.skill2
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(tapGestureRecognizer2)
        
        withWhomLabel.text = EnterViewController.isEnglish ? "With whom:" : "С кем:"
        whatGive.text = EnterViewController.isEnglish ? "What give:" : "Что даю:"
        whatReceive.text = EnterViewController.isEnglish ? "What receive:" : "Что получаю:"
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        action(tapGestureRecognizer, transaction, user)
    }
    
    private func makeRequest(mail: String) {
        Api.shared.getUserByEmail(email: mail) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    if let imageBase64String = user?.photo {
                        let imageData = Data(base64Encoded: imageBase64String)
                        self.profileImage.image = UIImage(data: imageData!)
                    } else {
                        self.setDefaultImage()
                    }
                    self.nameLabel.text = user?.name!
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.setDefaultImage()
                    self.nameLabel.text = "No Name" }
            }
        }
    }
    
    private func setDefaultImage() {
        profileImage.image = UIImage(named: "crowsHoldingWings")
    }
}
