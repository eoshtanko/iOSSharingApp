//
//  ProfileViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    static var isEnglish = false
    private var isProfileInfoEditing = false
    
    private let formatter = DateFormatter()
    private let eduProgramPickerView = UIPickerView()
    private let dormPickerView = UIPickerView()
    private let eduStagePickerView = UIPickerView()
    private let campusLocationPickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var canButton: UIButton!
    @IBOutlet weak var wantButton: UIButton!
    @IBOutlet weak var russianLangButton: UIButton!
    @IBOutlet weak var englishLangButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var bottomButtom: UIButton!
    
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var socialNetworkTextField: UITextField!
    @IBOutlet weak var eduProgramTextField: UITextField!
    @IBOutlet weak var dormTextField: UITextField!
    @IBOutlet weak var stageOfEduTextField: UITextField!
    @IBOutlet weak var campusLocationTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var myDataLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var socialNetworkLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var eduProgramLabel: UILabel!
    @IBOutlet weak var dormLabel: UILabel!
    @IBOutlet weak var stageOfEduLabel: UILabel!
    @IBOutlet weak var campusLocationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    // MARK: @IBAction
    
    @IBAction func editPhotoButtonPressed(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func editProfileInfoButtonPressed(_ sender: Any) {
        isProfileInfoEditing = true
        editProfileButton.layer.isHidden = true
        bottomButtom.setTitle(ProfileViewController.isEnglish ? "Save" : "Сохранить", for: .normal)
        activateEditing()
    }
    
    @IBAction func canButtonPressed(_ sender: Any) {
        PersonalSkillListViewController.isContainedCanSkills = true
        goToPersonalSkillList()
    }
    
    @IBAction func wantButtonPressed(_ sender: Any) {
        PersonalSkillListViewController.isContainedCanSkills = false
        goToPersonalSkillList()
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        if isProfileInfoEditing {
            maleButton.tintColor = UIColor(named: "BlueDarkColor")
            femaleButton.tintColor = .gray
        }
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        if isProfileInfoEditing {
            femaleButton.tintColor = UIColor(named: "BlueDarkColor")
            maleButton.tintColor = .gray
        }
    }
    
    @IBAction func bottomButtonPressed(_ sender: Any) {
        if isProfileInfoEditing {
            editProfileButton.layer.isHidden = false
            bottomButtom.setTitle(ProfileViewController.isEnglish ? "Log out" : "Выйти из аккаунта", for: .normal)
            deactivateEditing()
        }
    }
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickerView()
        configureDatePicker()
        deactivateEditing()
        configureNavigationButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSubviews()
    }
    
    // MARK: Funcs
    
    private func configurePickerView() {
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
    
    private func configureDatePicker() {
        formatter.dateStyle = .short
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = formatter.date(from: "01.01.1970")
        datePicker.maximumDate = formatter.date(from: "31.12.2006")
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
    
    func configureNavigationButton() {
        let settingsButton = UIButton()
        if ProfileViewController.isEnglish {
            settingsButton.setTitle("🇷🇺", for: .normal)
        } else {
            settingsButton.setTitle("🇬🇧", for: .normal)
        }
        settingsButton.titleLabel?.font = .systemFont(ofSize: 30)
        settingsButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    private func configureSubviews() {
        configureProfileImageView()
        configureTextFields()
        configureButtons()
        ProfileViewController.isEnglish ? translateToEnglish() : translateToRussia()
    }
    
    @objc private func changeLanguage() {
        ExchangesViewController.tableView.reloadData()
        SearchViewController.tableView.reloadData()
        ConversationsListViewController.tableView.reloadData()
        if (ProfileViewController.isEnglish) {
            translateToRussia()
        } else {
            translateToEnglish()
        }
    }
    
    private func translateToRussia() {
        ProfileViewController.isEnglish = false
        configureNavigationButton()
        translateProfileView(isEnglish: false)
    }

    private func translateToEnglish() {
        ProfileViewController.isEnglish = true
        configureNavigationButton()
        translateProfileView(isEnglish: true)
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        if(CurrentUser.user.photo != nil) {
            profileImageView.image = CurrentUser.user.photo
        }
    }
    
    private func configureTextFields() {
        configureTextFieldsDelegate(textField: nameTextFiled)
        configureTextFieldsDelegate(textField: surnameTextField)
        configureTextFieldsDelegate(textField: emailTextField)
        configureTextFieldsDelegate(textField: socialNetworkTextField)
        configureTextView()
    }
    
    private func configureButtons() {
        makeButtonCircle(button: editPhotoButton)
        makeButtonCircle(button: editProfileButton)
        makeButtonOval(button: canButton)
        makeButtonOval(button: wantButton)
        makeButtonOval(button: bottomButtom)
    }
    
    private func configureTextView() {
        aboutMeTextView.delegate = self
        aboutMeTextView.layer.borderWidth = 0.5
        aboutMeTextView.layer.borderColor = CGColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        aboutMeTextView.layer.cornerRadius = 10
    }
    
    private func configureTextFieldsDelegate(textField: UITextField) {
        textField.delegate = self
    }
    
    private func makeButtonCircle(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
    }
    
    private func makeButtonOval(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    private func translateProfileView(isEnglish: Bool) {
        if (isEnglish) {
            myDataLabel.text = "My information"
            nameLabel.text = "Name"
            nameTextFiled.placeholder = "Enter a name"
            surnameLabel.text = "Surname"
            surnameTextField.placeholder = "Enter a surname"
            emailTextField.placeholder = "Enter email"
            socialNetworkLabel.text = "Social network"
            socialNetworkTextField.placeholder = "Enter the link to the social network"
            aboutMeLabel.text = "About me"
            canButton.setTitle("Can", for: .normal)
            wantButton.setTitle("Want", for: .normal)
            if (aboutMeTextView.text == "Я...") {
                aboutMeTextView.text = "I am..."
            }
            eduProgramLabel.text = "Educational program"
            eduProgramTextField.placeholder = "Choose an educational program"
            dormLabel.text = "Dormitory"
            dormTextField.placeholder = "Choose a dormitory"
            stageOfEduLabel.text = "Stage of education"
            stageOfEduTextField.placeholder = "Choose a stage of education"
            campusLocationLabel.text = "Campus location"
            campusLocationTextField.placeholder = "Choose a campus location"
            genderLabel.text = "Gender"
            maleButton.setTitle("Male", for: .normal)
            femaleButton.setTitle("Female", for: .normal)
            birthdayLabel.text = "Birthday date"
            birthdayTextField.placeholder = "Choose a birthday date"
            if isProfileInfoEditing {
                bottomButtom.setTitle("Save", for: .normal)
            } else {
                bottomButtom.setTitle("Log out", for: .normal)
            }
        } else {
            myDataLabel.text = "Мои данные"
            nameLabel.text = "Имя"
            nameTextFiled.placeholder = "Введите имя"
            surnameLabel.text = "Фамилия"
            surnameTextField.placeholder = "Введите фамилию"
            emailTextField.placeholder = "Введите почту"
            socialNetworkLabel.text = "Социальная сеть"
            socialNetworkTextField.placeholder = "Введите ссылку на социальную сеть"
            aboutMeLabel.text = "Обо мне"
            canButton.setTitle("Могу", for: .normal)
            wantButton.setTitle("Хочу", for: .normal)
            if (aboutMeTextView.text == "I am...") {
                aboutMeTextView.text = "Я..."
            }
            eduProgramLabel.text = "Образовательная программа"
            eduProgramTextField.placeholder = "Выберите образовательную программу"
            dormLabel.text = "Общежитие"
            dormTextField.placeholder = "Выберите общежитие"
            stageOfEduLabel.text = "Ступень обучения"
            stageOfEduTextField.placeholder = "Выберите ступень обучения"
            campusLocationLabel.text = "Расположение корпуса"
            campusLocationTextField.placeholder = "Выберете расположение корпуса"
            genderLabel.text = "Пол"
            maleButton.setTitle("Мужской", for: .normal)
            femaleButton.setTitle("Женский", for: .normal)
            birthdayLabel.text = "Дата рождения"
            birthdayTextField.placeholder = "Выберете дату рождения"
            if isProfileInfoEditing {
                bottomButtom.setTitle("Сохранить", for: .normal)
            } else {
                bottomButtom.setTitle("Выйти из аккаунта", for: .normal)
            }
        }
    }
    
    private func activateEditing() {
        nameTextFiled.isUserInteractionEnabled = true
        surnameTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        socialNetworkTextField.isUserInteractionEnabled = true
        eduProgramTextField.isUserInteractionEnabled = true
        dormTextField.isUserInteractionEnabled = true
        stageOfEduTextField.isUserInteractionEnabled = true
        campusLocationTextField.isUserInteractionEnabled = true
        birthdayTextField.isUserInteractionEnabled = true
        aboutMeTextView.isUserInteractionEnabled = true
        maleButton.isUserInteractionEnabled = true
        femaleButton.isUserInteractionEnabled = true
    }
    
    private func deactivateEditing() {
        nameTextFiled.isUserInteractionEnabled = false
        surnameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        socialNetworkTextField.isUserInteractionEnabled = false
        eduProgramTextField.isUserInteractionEnabled = false
        dormTextField.isUserInteractionEnabled = false
        stageOfEduTextField.isUserInteractionEnabled = false
        campusLocationTextField.isUserInteractionEnabled = false
        birthdayTextField.isUserInteractionEnabled = false
        aboutMeTextView.isUserInteractionEnabled = false
        maleButton.isUserInteractionEnabled = false
        femaleButton.isUserInteractionEnabled = false
    }
    
    private func goToPersonalSkillList() {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "PersonalSkillList", bundle: nil)
        let personalSkillListViewController = storyboard.instantiateViewController(withIdentifier: "PersonalSkillList") as! PersonalSkillListViewController
        
        navigationController?.pushViewController(personalSkillListViewController, animated: true)
    }
    
    private enum Const {
        static let buttonBorderRadius: CGFloat = 14
        static let maxNumOfCharsInName = 16
    }
}

// Все, что связано с UITextField.
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension ProfileViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// Все, что связано с установкой фото.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = image
        } else {
            self.showAlertWith(message: "No image found.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func pickImage() {
        let imagePickerController = configureImagePickerController()
        let actionSheet = configureActionSheet()
        configureActions(actionSheet, imagePickerController)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func configureImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
    
    private func configureActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(
            title: ProfileViewController.isEnglish ? "Image Source" : "Источник фотографии",
            message: ProfileViewController.isEnglish ? "Select the source of your profile image" : "Выберите источник фотографии профиля", preferredStyle: .actionSheet)
        return actionSheet
    }
    
    private func configureActions(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        configureLibraryAction(actionSheet, imagePickerController)
        configureCameraAction(actionSheet, imagePickerController)
        configureCancelAction(actionSheet)
    }
    
    private func configureLibraryAction(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        actionSheet.addAction(UIAlertAction(
            title: ProfileViewController.isEnglish ? "Photo Library" : "Галерея", style: .default, handler: { (action: UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            } else {
                self.showAlertWith(
                    message: ProfileViewController.isEnglish ? "Unable to access the photo library." : "Не удается получить доступ к библиотеке фотографий")
            }
        }))
    }
    
    private func configureCameraAction(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        actionSheet.addAction(UIAlertAction(
            title: ProfileViewController.isEnglish ? "Camera" : "Камера", style: .default, handler: { (action: UIAlertAction) in
            actionSheet.dismiss(animated: true) {
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true)
                } else {
                    self.showAlertWith(
                        message: ProfileViewController.isEnglish ? "Unable to access the camera" : "Не удается получить доступ к камере")
                }
            }
        }))
    }
    
    private func configureCancelAction(_ actionSheet: UIAlertController) {
        actionSheet.addAction(UIAlertAction(
            title: ProfileViewController.isEnglish ? "Cancel" : "Отмена", style: .cancel, handler: nil))
    }
    
    private func showAlertWith(message: String){
        let alertController = UIAlertController(
            title: ProfileViewController.isEnglish ? "Error when uploading a photo" : "Ошибка при загрузке фотографии", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: ProfileViewController.isEnglish ? "OK" : "Ладушки", style: .default))
        present(alertController, animated: true)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return !ProfileViewController.isEnglish ?  DataInRussian.eduPrograms.count : DataInEnglish.eduPrograms.count
        case 2:
            return !ProfileViewController.isEnglish ?  DataInRussian.dormitories.count : DataInEnglish.dormitories.count
        case 3:
            return !ProfileViewController.isEnglish ?  DataInRussian.stagesOfEdu.count : DataInEnglish.stagesOfEdu.count
        case 4:
            return !ProfileViewController.isEnglish ?  DataInRussian.universityCampuses.count : DataInEnglish.universityCampuses.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return !ProfileViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
        case 2:
            return !ProfileViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
        case 3:
            return !ProfileViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
        case 4:
            return !ProfileViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            eduProgramTextField.text = !ProfileViewController.isEnglish ? DataInRussian.eduPrograms[row] : DataInEnglish.eduPrograms[row]
            eduProgramTextField.resignFirstResponder()
        case 2:
            dormTextField.text = !ProfileViewController.isEnglish ? DataInRussian.dormitories[row] : DataInEnglish.dormitories[row]
            dormTextField.resignFirstResponder()
        case 3:
            stageOfEduTextField.text = !ProfileViewController.isEnglish ? DataInRussian.stagesOfEdu[row] : DataInEnglish.stagesOfEdu[row]
            stageOfEduTextField.resignFirstResponder()
        case 4:
            campusLocationTextField.text = !ProfileViewController.isEnglish ? DataInRussian.universityCampuses[row] : DataInEnglish.universityCampuses[row]
            campusLocationTextField.resignFirstResponder()
        default:
            return
        }
    }
}
