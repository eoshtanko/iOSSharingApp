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
    var editingSkill: Skill!
    var isCanSkill: Bool!
    
    private var activityIndicator: UIActivityIndicatorView!
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
        activityIndicator.startAnimating()
        if skill != nil {
            editRequest()
        } else {
            createRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEditingSkill()
        configureActivityIndicator()
        configureTextViewHintText()
        setData()
        if categoryTextField.text == nil || categoryTextField.text!.isEmpty {
            subcategoryTextField.isHidden = true
            subcategoryLabel.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureButtons()
        configureTextFields()
        configureTextView()
        configurePickerView()
        setLanguage()
    }
    
    func configureEditingSkill() {
        editingSkill = Skill(id: skill?.id ?? 0,
                             status: isCanSkill ? 1 : 2,
                             name: skill?.name ?? "",
                             description: skill?.description ?? "",
                             category: skill?.category ?? 0,
                             subcategory: skill?.subcategory ?? 0,
                             userMail: CurrentUser.user.mail!,
                             userName: CurrentUser.user.name!,
                             userSurname: CurrentUser.user.surname!,
                             photo: CurrentUser.user.photo)
    }
    
    func setSkill(_ skill: Skill) {
        self.skill = skill
    }
    
    private func editRequest() {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.editSkill(skill: editingSkill) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.performSegue(withIdentifier: "unwindToPersonalSkillList", sender: nil)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func createRequest() {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.createSkill(skill: editingSkill) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.performSegue(withIdentifier: "unwindToPersonalSkillList", sender: nil)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: (EnterViewController.isEnglish ? "Network error" : "Ошибка сети"), message: EnterViewController.isEnglish ? "The data was not saved. Check the internet and try again." : "Данные не были сохранены. Проверьте интернет и попробуйте снова.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    private func configureTextViewHintText() {
        if editingSkill?.description.isEmpty ?? true {
            descriptionTextView.text = EnterViewController.isEnglish ? "Add a description of the skill" : "Добавьте описание навыка"
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
        subcategoryTextField.isEnabled = editingSkill != nil
    }
    
    private func configureTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = CGColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        descriptionTextView.layer.cornerRadius = 10
    }
    
    private func setLanguage() {
        titleLabel.text = isCanSkill ? EnterViewController.isEnglish ? "I can" : "Я могу" : EnterViewController.isEnglish ? "I want" : "Я хочу"
        nameOfSkillLabel.text = EnterViewController.isEnglish ? "Skill name" : "Название навыка"
        descriptionLabel.text = EnterViewController.isEnglish ? "Skill description" : "Описание навыка"
        categoryLabel.text = EnterViewController.isEnglish ? "Category" : "Категория"
        subcategoryLabel.text = EnterViewController.isEnglish ? "Subcategory" : "Подкатегория"
        
        nameOfSkillTextField.placeholder = EnterViewController.isEnglish ? "Enter the skill name" : "Введите название навыка"
        categoryTextField.placeholder = EnterViewController.isEnglish ? "Select a category" : "Выберите категорию"
        subcategoryTextField.placeholder = EnterViewController.isEnglish ? "Select a subcategory" : "Выберите подкатегорию"
        
        saveButton.setTitle(EnterViewController.isEnglish ? "Save" : "Сохранить", for: .normal)
    }
}

extension SkillEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameIsValid = textField.text?.isNameOfSkillValid() ?? false
        if nameIsValid {
            editingSkill?.name = textField.text!
        }
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
        editingSkill?.description = textView.text
        if textView.text.isEmpty {
            textView.text = EnterViewController.isEnglish ? "Add a description of the skill" : "Добавьте описание навыка"
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
            if categoryTextField.text == nil || categoryTextField.text!.isEmpty {
                return 0
            }
            if editingSkill?.category == 0 {
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
            if editingSkill?.category == 0 {
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
            let prevText = categoryTextField.text
            subcategoryTextField.isEnabled = true
            categoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.categories[row] : DataInEnglish.categories[row]
            categoryTextField.resignFirstResponder()
            editingSkill?.category = row
            subcategoryTextField.isHidden = false
            subcategoryLabel.isHidden = false
            
            if !(prevText == nil || prevText!.isEmpty || prevText == DataInRussian.categories[row] || prevText == DataInEnglish.categories[row]) {
                subcategoryTextField.text = ""
            }
        case 2:
            if editingSkill?.category == 0 {
                subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy[row] : DataInEnglish.subcategoriesStudy[row]
            } else {
            subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy[row] : DataInEnglish.subcategoriesNonStudy[row]
            }
            editingSkill?.subcategory = row
            subcategoryTextField.resignFirstResponder()
        default:
            return
        }
        changeValidEditingStatus()
    }
}

