//
//  ExchangeCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 14.03.2022.
//

import UIKit

class СompletedExchangeCell: UITableViewCell {
    
    static let identifier = String(describing: СompletedExchangeCell.self)
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var withWhomLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var whatReceive: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var whatGive: UILabel!
    @IBOutlet weak var giveLabel: UILabel!
    
    var transaction: Transaction!
    var action: ((UITapGestureRecognizer, Transaction, User?) -> Void)!
    var user: User?
    
    func configureCell(_ transaction: Transaction, _ action: @escaping ((UITapGestureRecognizer, Transaction, User?) -> Void)) {
        self.transaction = transaction
        self.action = action
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
        profileImage.image = UIImage(systemName: "person.fill")
        profileImage.tintColor = UIColor(named: "DefaultImageColor")
        profileImage.backgroundColor = UIColor(named: "BackgroundImageColor")
    }
    
}
