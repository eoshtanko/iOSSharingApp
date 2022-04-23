//
//  SelectionOfParametersViewController + UIPickerView.swift
//  HSE Sharing
//
//  Created by Екатерина on 15.04.2022.
//

import UIKit

extension SelectionOfParametersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configurePickerView() {
        categoryPickerView.tag = 1
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryTextField.inputView = categoryPickerView
        
        subcategoryPickerView.tag = 2
        subcategoryPickerView.delegate = self
        subcategoryPickerView.dataSource = self
        subcategoryTextField.inputView = subcategoryPickerView
        
        typePickerView.tag = 3
        typePickerView.delegate = self
        typePickerView.dataSource = self
        typeTextField.inputView = typePickerView
        
        eduProgramPickerView.tag = 4
        eduProgramPickerView.delegate = self
        eduProgramPickerView.dataSource = self
        eduProgramTextField.inputView = eduProgramPickerView
        
        dormPickerView.tag = 6
        dormPickerView.delegate = self
        dormPickerView.dataSource = self
        dormTextField.inputView = dormPickerView
        
        stageOfEduPickerView.tag = 7
        stageOfEduPickerView.delegate = self
        stageOfEduPickerView.dataSource = self
        stageOfEduTextField.inputView = stageOfEduPickerView
        
        campusLocationPickerView.tag = 5
        campusLocationPickerView.delegate = self
        campusLocationPickerView.dataSource = self
        campusLocationTextField.inputView = campusLocationPickerView
        
        genderPickerView.tag = 8
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        campusLocationTextField.inputView = genderPickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ?  DataInRussian.categories.count : DataInEnglish.categories.count
        case 2:
            if categoryIsStudy {
                return !EnterViewController.isEnglish ?  DataInRussian.subcategoriesStudy.count : DataInEnglish.subcategoriesStudy.count
            } else {
                return !EnterViewController.isEnglish ?  DataInRussian.subcategoriesNonStudy.count : DataInEnglish.subcategoriesNonStudy.count
            }
        case 3:
            return !EnterViewController.isEnglish ?  DataInRussian.statuses.count : DataInEnglish.statuses.count
        case 4:
            return !EnterViewController.isEnglish ?  DataInRussian.eduPrograms.count : DataInEnglish.eduPrograms.count
        case 5:
            return !EnterViewController.isEnglish ?  DataInRussian.universityCampuses.count : DataInEnglish.universityCampuses.count
        case 6:
            return !EnterViewController.isEnglish ?  DataInRussian.dormitories.count : DataInEnglish.dormitories.count
        case 7:
            return !EnterViewController.isEnglish ?  DataInRussian.stagesOfEdu.count : DataInEnglish.stagesOfEdu.count
        case 8:
            return !EnterViewController.isEnglish ?  DataInRussian.gender.count : DataInEnglish.gender.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ? DataInRussian.categories[row] : DataInEnglish.categories[row]
        case 2:
            if categoryIsStudy {
                return !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy[row] : DataInEnglish.subcategoriesStudy[row]
            } else {
                return !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy[row] : DataInEnglish.subcategoriesNonStudy[row]
            }
        case 3:
            return !EnterViewController.isEnglish ? DataInRussian.statuses[row] : DataInEnglish.statuses[row]
        case 4:
            return !EnterViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
        case 5:
            return !EnterViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
        case 6:
            return !EnterViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
        case 7:
            return !EnterViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
        case 8:
            return !EnterViewController.isEnglish ? DataInRussian.gender[row] : DataInEnglish.gender[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let prevText = categoryTextField.text
            if row == 0 {
                categoryTextField.text = nil
                searchParametrs.category = -1
                subcategoryTextField.isEnabled = false
                subcategoryTextField.text = ""
            } else {
                subcategoryTextField.isEnabled = true
                categoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.categories[row] : DataInEnglish.categories[row]
                categoryIsStudy = row == 1
                if !(prevText == nil || prevText!.isEmpty || prevText == DataInRussian.categories[row] || prevText == DataInEnglish.categories[row]) {
                    subcategoryTextField.text = ""
                }
            }
            searchParametrs.category = row
            categoryTextField.resignFirstResponder()
        case 2:
            if row == 0 {
                subcategoryTextField.text = nil
                searchParametrs.subcategory = -1
            } else {
                if categoryIsStudy {
                    subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesStudy[row] : DataInEnglish.subcategoriesStudy[row]
                } else {
                    subcategoryTextField.text = !EnterViewController.isEnglish ? DataInRussian.subcategoriesNonStudy[row] : DataInEnglish.subcategoriesNonStudy[row]
                }
            }
            searchParametrs.subcategory = row
            subcategoryTextField.resignFirstResponder()
        case 3:
            if row == 0 {
                typeTextField.text = nil
                searchParametrs.skillstatus = -1
            } else {
                typeTextField.text = !EnterViewController.isEnglish ? DataInRussian.statuses[row] : DataInEnglish.statuses[row]
            }
            typeTextField.resignFirstResponder()
            searchParametrs.skillstatus = row
        case 4:
            if row == 0 {
                eduProgramTextField.text = nil
                searchParametrs.majorID = -1
            } else {
                eduProgramTextField.text = !EnterViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
            }
            eduProgramTextField.resignFirstResponder()
            searchParametrs.majorID = row
        case 5:
            if row == 0 {
                campusLocationTextField.text = nil
                searchParametrs.campusLocationID = -1
            } else {
                campusLocationTextField.text = !EnterViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
            }
            campusLocationTextField.resignFirstResponder()
            searchParametrs.campusLocationID = row
        case 6:
            if row == 0 {
                dormTextField.text = nil
                searchParametrs.dormitoryID = -1
            } else {
                dormTextField.text = !EnterViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
            }
            dormTextField.resignFirstResponder()
            searchParametrs.dormitoryID = row
        case 7:
            if row == 0 {
                stageOfEduTextField.text = nil
                searchParametrs.studyingYearID = -1
            } else {
                stageOfEduTextField.text = !EnterViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
            }
            stageOfEduTextField.resignFirstResponder()
            searchParametrs.studyingYearID = row
        case 8:
            if row == 0 {
                genderTextField.text = nil
                searchParametrs.gender = -1
            } else {
                genderTextField.text = !EnterViewController.isEnglish ? DataInRussian.gender[row] : DataInEnglish.gender[row]
            }
            genderTextField.resignFirstResponder()
            searchParametrs.gender = row
        default:
            return
        }
        setEnableStatusToButton()
    }
}

