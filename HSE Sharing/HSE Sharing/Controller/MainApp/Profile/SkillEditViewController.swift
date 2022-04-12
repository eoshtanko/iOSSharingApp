//
//  SkillEditViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 06.04.2022.
//

import Foundation
import UIKit

class SkillEditViewController: UIViewController {
    
    var skill: Skill?
    
    private var nameIsValid: Bool = true
    
    let categoryPickerView = UIPickerView()
    let subcategoryPickerView = UIPickerView()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameOfSkillLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    
    @IBOutlet weak var nameOfSkillTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subcategoryTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if skill != nil {
            editRequest()
        } else {
            createRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextViewHintText()
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureButtons()
        configureTextFields()
        configureTextView()
        configurePickerView()
    }
    
    func setSkill(_ skill: Skill) {
        self.skill = skill
    }
    
    private func editRequest() {
        
    }
    
    private func createRequest() {
        
    }
    
    private func configureTextViewHintText() {
        if skill?.description.isEmpty ?? true {
            descriptionTextView.text = "Добавьте описание навыка"
            descriptionTextView.textColor = .lightGray
        }
    }
    
    private func setData() {
        if let skill = skill {
            nameOfSkillTextField.text = skill.name
            descriptionTextView.text = skill.description
            if EnterViewController.isEnglish {
                categoryTextField.text = DataInEnglish.categories[skill.category]
                if skill.category == 0 {
                    subcategoryTextField.text = DataInEnglish.subcategoriesStudy[skill.subcategory]
                } else {
                    subcategoryTextField.text = DataInEnglish.subcategoriesNonStudy[skill.subcategory]
                }
            } else {
                categoryTextField.text = DataInRussian.categories[skill.category]
                if skill.category == 0 {
                    subcategoryTextField.text = DataInRussian.subcategoriesStudy[skill.subcategory]
                } else {
                    subcategoryTextField.text = DataInRussian.subcategoriesNonStudy[skill.subcategory]
                }
            }
        }
    }
    
    private func configureButtons() {
        saveButton.makeButtonOval()
    }
    
    private func configureTextFields() {
        nameOfSkillTextField.delegate = self
        subcategoryTextField.isEnabled = skill != nil
    }
    
    private func configureTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = CGColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        descriptionTextView.layer.cornerRadius = 10
    }
}

extension SkillEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameIsValid = textField.text?.isNameOfSkillValid() ?? false
        changeValidEditingStatus()
    }
    
    func changeValidEditingStatus() {
        nameOfSkillTextField.changeColorOfBorder(isValid: nameIsValid)
        saveButton.isEnabled = nameIsValid && !(categoryTextField.text?.isEmpty ?? true) && !(subcategoryTextField.text?.isEmpty ?? true)
    }
}

extension SkillEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Добавьте описание навыка"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension SkillEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configurePickerView() {
        categoryPickerView.tag = 1
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryTextField.inputView = categoryPickerView
        
        subcategoryPickerView.tag = 2
        subcategoryPickerView.delegate = self
        subcategoryPickerView.dataSource = self
        subcategoryTextField.inputView = subcategoryPickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ?  DataInRussian.categories.count : DataInEnglish.categories.count
        case 2:
            if skill?.category == 0 {
            return !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy.count : DataInEnglish.subcategoriesStudy.count
            }
            return !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy.count : DataInEnglish.subcategoriesNonStudy.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ? DataInRussian.categories[row] : DataInEnglish.categories[row]
        case 2:
            if skill?.category == 0 {
            return !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy[row] : DataInEnglish.subcategoriesStudy[row]
            }
            return !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy[row] : DataInEnglish.subcategoriesNonStudy[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            subcategoryTextField.isEnabled = true
            categoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.categories[row] : DataInEnglish.categories[row]
            categoryTextField.resignFirstResponder()
        case 2:
            if skill?.category == 0 {
                subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy[row] : DataInEnglish.subcategoriesStudy[row]
            } else {
            subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy[row] : DataInEnglish.subcategoriesNonStudy[row]
            }
            subcategoryTextField.resignFirstResponder()
        default:
            return
        }
    }
}

