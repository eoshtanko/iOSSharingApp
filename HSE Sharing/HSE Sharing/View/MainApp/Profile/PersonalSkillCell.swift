//
//  PersonalSkillCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.03.2022.
//

import UIKit

class PersonalSkillCell: UITableViewCell {
    
    static let identifier = String(describing: PersonalSkillCell.self)
    var deleteSkill: ((Int64) -> Void)?
    var editSkill: ((Skill) -> Void)?
    private var skill: Skill?
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var subcategoryTextLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if let skill = skill {
            editSkill?(skill)
        }
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteSkill?(skill!.id)
    }
    
    func setDeleteSkillAction(_ deleteSkill: ((Int64) -> Void)?) {
        self.deleteSkill = deleteSkill
    }
    
    func setEditSkillAction(_ editSkill: ((Skill) -> Void)?) {
        self.editSkill = editSkill
    }
    
    func configureCell(_ skill: Skill) {
        deleteButton.isHidden = skill.userMail != CurrentUser.user.mail
        editButton.isHidden = skill.userMail != CurrentUser.user.mail
        configureLabelsLanguage()
        configureData(skill)
        configureView()
    }

    private func configureLabelsLanguage() {
        nameLabel.text = EnterViewController.isEnglish ? "Skill:" : "Навык:"
        descriptionLabel.text = EnterViewController.isEnglish ? "Description:" : "Описание:"
        categoryLabel.text = EnterViewController.isEnglish ? "Category:" : "Категория:"
        subcategoryLabel.text = EnterViewController.isEnglish ? "Subcategory:" : "Подкатегория:"
    }
    
    private func configureData(_ skill: Skill) {
        self.skill = skill
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        categoryTextLabel.text = EnterViewController.isEnglish ? DataInEnglish.categories[skill.category] : DataInRussian.categories[skill.category]
        if skill.category == 0 {
        subcategoryTextLabel.text = EnterViewController.isEnglish ? DataInEnglish.subcategoriesStudy[skill.subcategory] : DataInRussian.subcategoriesStudy[skill.subcategory]
        } else {
            subcategoryTextLabel.text = EnterViewController.isEnglish ? DataInEnglish.subcategoriesNonStudy[skill.subcategory] : DataInRussian.subcategoriesNonStudy[skill.subcategory]
        }
    }
    
    private func configureView() {
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
    }
}
