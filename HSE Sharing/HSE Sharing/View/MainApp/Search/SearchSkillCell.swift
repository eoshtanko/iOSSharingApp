//
//  SearchSkillCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.03.2022.
//

import UIKit

class SearchSkillCell: UITableViewCell {
    
    static let identifier = String(describing: SearchSkillCell.self)
    
    @IBOutlet weak var photoOfAuthorImageView: UIImageView!
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var typeOfSkillTextLabel: UILabel!
    @IBOutlet weak var authorNameTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var subcategoryTextLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    
    var action: ((UITapGestureRecognizer, String) -> Void)!
    var createNewTransaction: ((Skill) -> Void)!
    var skill: Skill!
    
    @IBAction func exchangeButtonPresssed(_ sender: Any) {
        createNewTransaction(skill)
    }
    
    func configureCell(_ skill: Skill, _ action: @escaping ((UITapGestureRecognizer, String) -> Void), _ createNewTransaction: @escaping ((Skill) -> Void)) {
        self.skill = skill
        self.action = action
        self.createNewTransaction = createNewTransaction
        exchangeButton.makeButtonOval()
        nameLabel.text = EnterViewController.isEnglish ? "Skill:" : "Навык:"
        descriptionLabel.text = EnterViewController.isEnglish ? "Description:" : "Описание:"
        categoryLabel.text = EnterViewController.isEnglish ? "Category:" : "Категория:"
        subcategoryLabel.text = EnterViewController.isEnglish ? "Subcategory:" : "Подкатегория:"
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        if let imageBase64String = skill.userPhoto {
            let imageData = Data(base64Encoded: imageBase64String)
            self.photoOfAuthorImageView.image = UIImage(data: imageData!)
        } else {
            setDefaultImage()
        }
        authorNameTextLabel.text = skill.userName
        if EnterViewController.isEnglish {
            categoryTextLabel.text = DataInEnglish.categories[skill.category]
            if skill.category == 0 {
            subcategoryTextLabel.text = DataInEnglish.subcategoriesStudy[skill.subcategory]
            } else {
                subcategoryTextLabel.text = DataInEnglish.subcategoriesNonStudy[skill.subcategory]
            }
            typeOfSkillTextLabel.text = skill.status == 1 ? "can" : "want"
        } else {
            categoryTextLabel.text = DataInRussian.categories[skill.category]
            if skill.category == 0 {
            subcategoryTextLabel.text = DataInRussian.subcategoriesStudy[skill.subcategory]
            } else {
                subcategoryTextLabel.text = DataInRussian.subcategoriesNonStudy[skill.subcategory]
            }
            typeOfSkillTextLabel.text = skill.status == 1 ? "может" : "хочет"
        }
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
        photoOfAuthorImageView.layer.cornerRadius = photoOfAuthorImageView.frame.size.width / 2
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoOfAuthorImageView.isUserInteractionEnabled = true
        photoOfAuthorImageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        nameTextLabel.isUserInteractionEnabled = true
        nameTextLabel.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        action(tapGestureRecognizer, skill.userMail)
    }
    
    private func setDefaultImage() {
        photoOfAuthorImageView.image = UIImage(named: "crowsHoldingWings")
    }
}
