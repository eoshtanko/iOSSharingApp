//
//  ExchangeCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 14.03.2022.
//

import UIKit

class ExchangeCell: UITableViewCell {
    
    static let identifier = String(describing: ExchangeCell.self)
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var withWhomLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var whatReceive: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var whatGive: UILabel!
    @IBOutlet weak var giveLabel: UILabel!
    
    func configureCell(_ transaction: Transaction) {
        withWhomLabel.text = ProfileViewController.isEnglish ? "With whom:" : "С кем:"
        whatReceive.text = ProfileViewController.isEnglish ? "What receive:" : "Что получаю:"
        whatGive.text = ProfileViewController.isEnglish ? "What give:" : "Что даю:"
        profileImage.image = transaction.userPhoto
        nameLabel.text = transaction.userName
        receiveLabel.text = transaction.skill1
        giveLabel.text = transaction.skill2
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
}
