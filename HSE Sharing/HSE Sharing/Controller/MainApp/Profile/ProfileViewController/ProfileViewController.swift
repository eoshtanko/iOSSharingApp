//
//  ProfileViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isMyProfile = true
    var currentUser: User?
    var prevImage: UIImage!
    
    var isProfileInfoEditing = false
    var nameIsValid: Bool = true
    var surnameIsValid: Bool = true
    var emailIsValid: Bool = true
    var socialNetworkIsValid: Bool = true
    
    let formatter = DateFormatter()
    let eduProgramPickerView = UIPickerView()
    let dormPickerView = UIPickerView()
    let eduStagePickerView = UIPickerView()
    let campusLocationPickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var chatButton: UIButton!
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
    @IBOutlet weak var changePasswordButton: UIButton!
    
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
    
    @IBOutlet weak var isModerSymbol: UIImageView!
    @IBOutlet weak var topBottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBottomButtonConstraint: NSLayoutConstraint!
    
    @IBAction func unwindToProfileViewController(segue:UIStoryboardSegue) { }
    
    @IBAction func editPhotoButtonPressed(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsListViewController = storyboard.instantiateViewController(withIdentifier: "Comments") as! CommentsViewController
        if !isMyProfile && CurrentUser.user.isModer ?? false {
            commentsListViewController.setNeedsFocusUpdate()
        }
        commentsListViewController.userMail = CurrentUser.user.mail
        navigationController?.pushViewController(commentsListViewController, animated: true)
    }
    
    @IBAction func editProfileInfoButtonPressed(_ sender: Any) {
        isProfileInfoEditing = true
        changePasswordButton.isHidden = false
        editProfileButton.layer.isHidden = true
        bottomButtom.setTitle(EnterViewController.isEnglish ? "Save" : "Сохранить", for: .normal)
        topBottomButtonConstraint.constant = 80
        bottomBottomButtonConstraint.constant = 40
        activateEditing()
    }
    
    @IBAction func canButtonPressed(_ sender: Any) {
        goToPersonalSkillList(skillStatus: 1)
    }
    
    @IBAction func wantButtonPressed(_ sender: Any) {
        goToPersonalSkillList(skillStatus: 2)
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
            makeRequest(isImageChanged: false)
        } else {
            logOut()
        }
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toChangePasswordScreen", sender: nil)
    }
    
    @IBAction func chatButtonPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChangePasswordViewController {
            destination.setUser(user: currentUser)
        }
    }
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        configureActivityIndicator()
        configurePickerView()
        configureDatePicker()
        deactivateEditing()
        configureNavigationButton()
        configureTapGestureRecognizer()
        configureData()
        configureTextViewHintText()
        editPhotoButton.isHidden = !(CurrentUser.user.mail == currentUser?.mail)
        editProfileButton.isHidden = editPhotoButton.isHidden
        bottomButtom.isHidden = editPhotoButton.isHidden
        chatButton.isHidden = !editPhotoButton.isHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSubviews()
    }
    
    // MARK: Funcs
    
    private func configureData() {
        if currentUser == nil {
            currentUser = getNewUser()
        }
        nameTextFiled.text = currentUser?.name
        surnameTextField.text = currentUser?.surname
        emailTextField.text = currentUser?.mail
        if let birthDate = currentUser?.birthDate, birthDate.get(.year) != 0001 {
            birthdayTextField.text = formatter.string(from: birthDate)
        }
        maleButton.tintColor = currentUser?.gender == 1 ? UIColor(named: "BlueDarkColor") : .gray
        femaleButton.tintColor = currentUser?.gender == 2 ? UIColor(named: "BlueDarkColor") : .gray
        if let studyingYearId = currentUser?.studyingYearId, studyingYearId != 0{
            stageOfEduTextField.text = DataInRussian.stagesOfEdu[studyingYearId]
        }
        if let majorId = currentUser?.majorId, majorId != 0 {
            eduProgramTextField.text = DataInRussian.eduPrograms[majorId]
        }
        if let campusLocationId = currentUser?.campusLocationId, campusLocationId != 0 {
            campusLocationTextField.text = DataInRussian.universityCampuses[campusLocationId]
        }
        if let dormitoryId = currentUser?.dormitoryId, dormitoryId != 0 {
            dormTextField.text = DataInRussian.dormitories[dormitoryId]
        }
        aboutMeTextView.text = currentUser?.about
        socialNetworkTextField.text = currentUser?.contact
        isModerSymbol.isHidden = !(currentUser?.isModer ?? false)
        if let imageBase64String = currentUser?.photo {
            let imageData = Data(base64Encoded: imageBase64String)
            profileImageView.image = UIImage(data: imageData!)
        }
        // averageGrade
    }
    
    private func getNewUser() -> User {
        return User(mail: CurrentUser.user.mail,
                    confirmationCodeServer: CurrentUser.user.confirmationCodeServer,
                    confirmationCodeUser: CurrentUser.user.confirmationCodeUser,
                    password: CurrentUser.user.password,
                    name: CurrentUser.user.name,
                    surname: CurrentUser.user.surname,
                    birthDate: CurrentUser.user.birthDate,
                    gender: CurrentUser.user.gender,
                    studyingYearId: CurrentUser.user.studyingYearId,
                    majorId: CurrentUser.user.majorId,
                    campusLocationId: CurrentUser.user.campusLocationId,
                    dormitoryId: CurrentUser.user.dormitoryId,
                    about: CurrentUser.user.about,
                    contact: CurrentUser.user.contact,
                    photo: CurrentUser.user.photo,
                    transactions: CurrentUser.user.transactions,
                    skills: CurrentUser.user.skills,
                    feedbacks: CurrentUser.user.feedbacks,
                    gradesCount: CurrentUser.user.gradesCount,
                    gradesSum: CurrentUser.user.gradesSum,
                    averageGrade: CurrentUser.user.averageGrade,
                    isModer: CurrentUser.user.isModer)
    }
    
    func makeRequest(isImageChanged: Bool) {
        activityIndicator.startAnimating()
        Api.shared.editUser(email: emailTextField.text!, user: currentUser!) { result in
            switch result {
            case .success(_):
                CurrentUser.user = self.currentUser!
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.transitFromEditingToNormalState()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert(isImageChanged: isImageChanged)
                }
            }
        }
    }
    
    private func showFailAlert(isImageChanged: Bool) {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Попробовать еще раз или отменить редактирование?", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "Еще раз", style: UIAlertAction.Style.default) { _ in
            self.makeRequest(isImageChanged: isImageChanged)
        })
        successAlert.addAction(UIAlertAction(title: "Сброс данных", style: UIAlertAction.Style.default) { _ in
            if isImageChanged {
                self.currentUser?.photo = self.prevImage.jpegData(compressionQuality: 1)?.base64EncodedString()
                self.profileImageView.image = self.prevImage
            } else {
                self.currentUser = nil
                self.configureData()
            }
        })
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
    
    private func transitFromEditingToNormalState() {
        changePasswordButton.isHidden = true
        isProfileInfoEditing = false
        editProfileButton.layer.isHidden = false
        bottomButtom.setTitle(EnterViewController.isEnglish ? "Log out" : "Выйти из аккаунта", for: .normal)
        topBottomButtonConstraint.constant = 40
        bottomBottomButtonConstraint.constant = 40
        deactivateEditing()
    }
    
    private func logOut() {
        currentUser = nil
        CurrentUser.user = nil
        self.performSegue(withIdentifier: "toEnterFromProfile", sender: nil)
    }
    
    private func configureTextViewHintText() {
        if aboutMeTextView.text.isEmpty || aboutMeTextView.textColor == .black {
            aboutMeTextView.text = CurrentUser.user.mail == currentUser?.mail ? "Расскажите о себе :)" : "Нет информации"
            aboutMeTextView.textColor = .lightGray
        }
    }
    
    func configureNavigationButton() {
        if currentUser?.mail == CurrentUser.user.mail {
            let settingsButton = UIButton()
            if EnterViewController.isEnglish {
                settingsButton.setTitle("🇷🇺", for: .normal)
            } else {
                settingsButton.setTitle("🇬🇧", for: .normal)
            }
            settingsButton.titleLabel?.font = .systemFont(ofSize: 30)
            settingsButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        }
    }
    
    private func configureSubviews() {
        configureProfileImageView()
        configureTextFields()
        configureButtons()
        EnterViewController.isEnglish ? translateToEnglish() : translateToRussia()
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    private func configureTextFields() {
        configureTextFieldsDelegate(textField: nameTextFiled)
        nameTextFiled.tag = 1
        configureTextFieldsDelegate(textField: surnameTextField)
        surnameTextField.tag = 2
        configureTextFieldsDelegate(textField: emailTextField)
        emailTextField.tag = 3
        configureTextFieldsDelegate(textField: socialNetworkTextField)
        socialNetworkTextField.tag = 4
        configureTextView()
    }
    
    private func configureButtons() {
        makeButtonCircle(button: editPhotoButton)
        makeButtonCircle(button: editProfileButton)
        canButton.makeButtonOval()
        wantButton.makeButtonOval()
        bottomButtom.makeButtonOval()
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
    
    private func goToPersonalSkillList(skillStatus: Int) {
        let storyboard = UIStoryboard(name: "PersonalSkillList", bundle: nil)
        let personalSkillListViewController = storyboard.instantiateViewController(withIdentifier: "PersonalSkillList") as! PersonalSkillListViewController
        personalSkillListViewController.skillStatus = skillStatus
        personalSkillListViewController.userEmail = currentUser?.mail
        navigationController?.pushViewController(personalSkillListViewController, animated: true)
    }
    
    private func configureTapGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    enum Const {
        static let buttonBorderRadius: CGFloat = 14
        static let maxNumOfCharsInName = 16
    }
}

extension ProfileViewController {
    
    @objc private func changeLanguage() {
        SearchViewController.tableView.reloadData()
        EnterViewController.isEnglish = !EnterViewController.isEnglish
        if (EnterViewController.isEnglish) {
            translateToRussia()
        } else {
            translateToEnglish()
        }
    }
    
    private func translateToRussia() {
        configureNavigationButton()
        translateProfileView(isEnglish: false)
    }
    
    private func translateToEnglish() {
        configureNavigationButton()
        translateProfileView(isEnglish: true)
    }
    
    private func translateProfileView(isEnglish: Bool) {
        if (isEnglish) {
            myDataLabel.text = CurrentUser.user.mail == currentUser?.mail ?  "My information" : "Information"
            nameLabel.text = "Name"
            nameTextFiled.placeholder = "Enter a name"
            surnameLabel.text = "Surname"
            surnameTextField.placeholder = "Enter a surname"
            emailTextField.placeholder = "Enter email"
            socialNetworkLabel.text = "Social network"
            socialNetworkTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ?  "t.me/ or vk.com/" :
            "Not specified"
            aboutMeLabel.text = "About me"
            canButton.setTitle("Can", for: .normal)
            wantButton.setTitle("Want", for: .normal)
            if (aboutMeTextView.text == "Я...") {
                aboutMeTextView.text = "I am..."
            }
            eduProgramLabel.text = "Educational program"
            eduProgramTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Choose an educational program" : "Not specified"
            dormLabel.text = "Dormitory"
            dormTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Choose a dormitory" : "Not specified"
            stageOfEduLabel.text = "Stage of education"
            stageOfEduTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Choose a stage of education" : "Not specified"
            campusLocationLabel.text = "Campus location"
            campusLocationTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Choose a campus location" : "Not specified"
            genderLabel.text = "Gender"
            maleButton.setTitle("Male", for: .normal)
            femaleButton.setTitle("Female", for: .normal)
            birthdayLabel.text = "Birthday date"
            birthdayTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Choose a birthday date" : "Not specified"
            if isProfileInfoEditing {
                bottomButtom.setTitle("Save", for: .normal)
            } else {
                bottomButtom.setTitle("Log out", for: .normal)
            }
            datePicker.locale = Locale(identifier: "en")
        } else {
            myDataLabel.text =  "Мои данные"
            nameLabel.text = "Имя"
            nameTextFiled.placeholder = "Введите имя"
            surnameLabel.text = "Фамилия"
            surnameTextField.placeholder = "Введите фамилию"
            emailTextField.placeholder = "Введите почту"
            socialNetworkLabel.text = "Социальная сеть"
            socialNetworkTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "t.me/ или vk.com/" : "Не указана"
            aboutMeLabel.text = "Обо мне"
            if CurrentUser.user.mail == currentUser?.mail || currentUser?.mail == nil {
                canButton.setTitle("Могу", for: .normal)
                wantButton.setTitle("Хочу", for: .normal)
            } else {
                canButton.setTitle("Может", for: .normal)
                wantButton.setTitle("Хочет", for: .normal)
            }
            if (aboutMeTextView.text == "I am...") {
                aboutMeTextView.text = "Я..."
            }
            eduProgramLabel.text = "Образовательная программа"
            eduProgramTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Выберите образовательную программу" : "Не указана"
            dormLabel.text = "Общежитие"
            dormTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Выберите общежитие" : "Не указано"
            stageOfEduLabel.text = "Ступень обучения"
            stageOfEduTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Выберите ступень обучения" : "Не указана"
            campusLocationLabel.text = "Расположение корпуса"
            campusLocationTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Выберете расположение корпуса" : "Не указано"
            genderLabel.text = "Пол"
            maleButton.setTitle("Мужской", for: .normal)
            femaleButton.setTitle("Женский", for: .normal)
            birthdayLabel.text = "Дата рождения"
            birthdayTextField.placeholder = CurrentUser.user.mail == currentUser?.mail ? "Выберете дату рождения" : "Не указана"
            if isProfileInfoEditing {
                bottomButtom.setTitle("Сохранить", for: .normal)
            } else {
                bottomButtom.setTitle("Выйти из аккаунта", for: .normal)
            }
            datePicker.locale = Locale(identifier: "ru")
        }
    }
}

