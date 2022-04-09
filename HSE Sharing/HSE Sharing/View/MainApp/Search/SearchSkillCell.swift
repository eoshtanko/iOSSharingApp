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
    
    func configureCell(_ skill: Skill) {
        nameLabel.text = ProfileViewController.isEnglish ? "Skill:" : "Навык:"
        descriptionLabel.text = ProfileViewController.isEnglish ? "Description:" : "Описание:"
        categoryLabel.text = ProfileViewController.isEnglish ? "Category:" : "Категория:"
        subcategoryLabel.text = ProfileViewController.isEnglish ? "Subcategory:" : "Подкатегория:"
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        photoOfAuthorImageView.image = skill.userPhoto
        authorNameTextLabel.text = skill.userName
        if ProfileViewController.isEnglish {
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
    }
}
