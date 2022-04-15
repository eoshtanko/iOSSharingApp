//
//  SelectionOfParametersViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class SelectionOfParametersViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var eduProgramLabel: UILabel!
    @IBOutlet weak var dormLabel: UILabel!
    @IBOutlet weak var stageOfEduLabel: UILabel!
    @IBOutlet weak var campusLocationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subcategoryTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var eduProgramTextField: UITextField!
    @IBOutlet weak var dormTextField: UITextField!
    @IBOutlet weak var stageOfEduTextField: UITextField!
    @IBOutlet weak var campusLocationTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    let categoryPickerView = UIPickerView()
    let subcategoryPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    let eduProgramPickerView = UIPickerView()
    let dormPickerView = UIPickerView()
    let stageOfEduPickerView = UIPickerView()
    let campusLocationPickerView = UIPickerView()
    let genderPickerView = UIPickerView()
    
    var categoryIsStudy: Bool = true
    var searchParametrs = SearchParametrs()
    
    var instanceOfSearchScreen: SearchViewController!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchParametrs.somethingIsChanged() {
            makeRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configurePickerView()
        searchButton.isEnabled = false
    }
    
    func setInstanceOfSearchScreen(_ instanceOfSearchScreen: SearchViewController) {
        self.instanceOfSearchScreen = instanceOfSearchScreen
    }
    
    private func makeRequest() {
        Api.shared.getSkillsByParametrs(params: searchParametrs) { result in
            switch result {
            case .success(let skills):
                DispatchQueue.main.async {
                    if let skills = skills {
                        self.instanceOfSearchScreen.setSkills(skills: skills)
                    }
                    self.performSegue(withIdentifier: "unwindToSearch", sender: nil)
                    self.activityIndicator.stopAnimating()
                    
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    func setEnableStatusToButton() {
        searchButton.isEnabled = searchParametrs.somethingIsChanged()
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.makeButtonOval()
    }
}

class SearchParametrs {
    var studyingYearID = -1
    var majorID = -1
    var campusLocationID = -1
    var dormitoryID = -1
    var gender = -1
    var skillstatus = -1
    var category = -1
    var subcategory = -1
    
    func somethingIsChanged() -> Bool {
        return studyingYearID != -1 || majorID != -1 || campusLocationID != -1 || dormitoryID != -1 || gender != -1 || skillstatus != -1 || category != -1 || subcategory != -1
    }
}
