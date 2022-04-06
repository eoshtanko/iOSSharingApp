//
//  PersonalSkillCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.03.2022.
//

import UIKit

class PersonalSkillCell: UITableViewCell {
    
    static let identifier = String(describing: PersonalSkillCell.self)
    
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editSkill?()
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteSkill?()
    }
    
    var deleteSkill: (() -> Void)?
    var editSkill: (() -> Void)?
    
    func setDeleteSkillAction(_ deleteSkill: (() -> Void)?) {
        self.deleteSkill = deleteSkill
    }
    
    func setEditSkillAction(_ editSkill: (() -> Void)?) {
        self.editSkill = editSkill
    }
    
    func configureCell(_ skill: Skill) {
        configureLabelsLanguage()
        configureData(skill)
        configureView()
    }

    private func configureLabelsLanguage() {
        nameLabel.text = ProfileViewController.isEnglish ? "Skill:" : "Навык:"
        descriptionLabel.text = ProfileViewController.isEnglish ? "Description:" : "Описание:"
        categoryLabel.text = ProfileViewController.isEnglish ? "Category:" : "Категория:"
        subcategoryLabel.text = ProfileViewController.isEnglish ? "Subcategory:" : "Подкатегория:"
    }
    
    private func configureData(_ skill: Skill) {
        nameTextLabel.text = skill.name
        descriptionTextLabel.text = skill.description
        categoryTextLabel.text = ProfileViewController.isEnglish ? DataInEnglish.categories[skill.category] : DataInRussian.categories[skill.category]
        if skill.category == 0 {
        subcategoryTextLabel.text = ProfileViewController.isEnglish ? DataInEnglish.subcategoriesStudy[skill.subcategory] : DataInRussian.subcategoriesStudy[skill.subcategory]
        } else {
            subcategoryTextLabel.text = ProfileViewController.isEnglish ? DataInEnglish.subcategoriesNonStudy[skill.subcategory] : DataInRussian.subcategoriesNonStudy[skill.subcategory]
        }
    }
    
    private func configureView() {
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
    }
}
