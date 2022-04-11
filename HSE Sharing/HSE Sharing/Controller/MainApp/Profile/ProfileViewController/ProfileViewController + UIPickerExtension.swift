//
//  ProfileViewController + UIPickerExtension.swift
//  HSE Sharing
//
//  Created by Екатерина on 03.04.2022.
//

import UIKit

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configurePickerView() {
        eduProgramPickerView.tag = 1
        eduProgramPickerView.delegate = self
        eduProgramPickerView.dataSource = self
        eduProgramTextField.inputView = eduProgramPickerView
        
        dormPickerView.tag = 2
        dormPickerView.delegate = self
        dormPickerView.dataSource = self
        dormTextField.inputView = dormPickerView
        
        eduStagePickerView.tag = 3
        eduStagePickerView.delegate = self
        eduStagePickerView.dataSource = self
        stageOfEduTextField.inputView = eduStagePickerView
        
        campusLocationPickerView.tag = 4
        campusLocationPickerView.delegate = self
        campusLocationPickerView.dataSource = self
        campusLocationTextField.inputView = campusLocationPickerView
    }
    
    func configureDatePicker() {
        formatter.dateStyle = .short
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -99, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        birthdayTextField.inputView = datePicker
        birthdayTextField.inputAccessoryView = createToolbar()
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc private func doneButtonPressed() {
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ?  DataInRussian.eduPrograms.count : DataInEnglish.eduPrograms.count
        case 2:
            return !EnterViewController.isEnglish ?  DataInRussian.dormitories.count : DataInEnglish.dormitories.count
        case 3:
            return !EnterViewController.isEnglish ?  DataInRussian.stagesOfEdu.count : DataInEnglish.stagesOfEdu.count
        case 4:
            return !EnterViewController.isEnglish ?  DataInRussian.universityCampuses.count : DataInEnglish.universityCampuses.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return !EnterViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
        case 2:
            return !EnterViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
        case 3:
            return !EnterViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
        case 4:
            return !EnterViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            if row == 0 {
                eduProgramTextField.text = nil
            } else {
                eduProgramTextField.text = !EnterViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
            }
            currentUser?.majorId = row
            eduProgramTextField.resignFirstResponder()
        case 2:
            if row == 0 {
                dormTextField.text = nil
            } else {
            dormTextField.text = !EnterViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
            }
            currentUser?.dormitoryId = row
            dormTextField.resignFirstResponder()
        case 3:
            if row == 0 {
                stageOfEduTextField.text = nil
            } else {
            stageOfEduTextField.text = !EnterViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
            }
            currentUser?.studyingYearId = row
            stageOfEduTextField.resignFirstResponder()
        case 4:
            if row == 0 {
                campusLocationTextField.text = nil
            } else {
            campusLocationTextField.text = !EnterViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
            }
            currentUser?.campusLocationId = row
            campusLocationTextField.resignFirstResponder()
        default:
            return
        }
    }
}

