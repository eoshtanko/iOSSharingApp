//
//  ForeignProfileViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 22.04.2022.
//

import Foundation

import UIKit

class ForeignProfileViewController: UIViewController {
    
    var currentUser: User?
    var userEmail: String?
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var canButton: UIButton!
    @IBOutlet weak var wantButton: UIButton!
    
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
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
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
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var isModerSymbol: UIImageView!

    @IBAction func commentsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsListViewController = storyboard.instantiateViewController(withIdentifier: "Comments") as! CommentsViewController
        if CurrentUser.user.isModer ?? false {
            commentsListViewController.setNeedsFocusUpdate()
        }
        commentsListViewController.userMail = currentUser!.mail!
        navigationController?.pushViewController(commentsListViewController, animated: true)
    }
    
    @IBAction func canButtonPressed(_ sender: Any) {
        goToPersonalSkillList(skillStatus: 1)
    }
    
    @IBAction func wantButtonPressed(_ sender: Any) {
        goToPersonalSkillList(skillStatus: 2)
    }

    @IBAction func chatButtonPressed(_ sender: Any) {
        getChatRequest()
    }
    
    private func getChatRequest() {
        activityIndicator.startAnimating()
        Api.shared.getConversations(email: CurrentUser.user.mail!) { result in
            switch result {
            case .success(let conversations):
                DispatchQueue.main.async {
                    var found = false
                    for c in conversations! {
                        if c.mail1 == self.currentUser?.mail || c.mail2 == self.currentUser?.mail {
                            self.activityIndicator.stopAnimating()
                            found = true
                            self.goToChat(conversation: c)
                            break
                        }
                    }
                    if !found {
                        self.createChatRequest()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                     self.showFailAlert()
                }
            }
        }
    }
    
    private func createChatRequest() {
        Api.shared.createConversation(conversation: Conversation(id: 0,
                                                                 lastMessage: "",
                                                                 sendTime: Formatter.iso8601.string(from: Date()),
                                                                 mail1: CurrentUser.user.mail!,
                                                                 name1:  CurrentUser.user.name!,
                                                                 surname1:  CurrentUser.user.surname!,
                                                                 photo1:  CurrentUser.user.photo,
                                                                 mail2: currentUser!.mail!,
                                                                 name2: currentUser!.name!,
                                                                 surname2: currentUser!.surname!,
                                                                 photo2: currentUser!.photo,
                                                                 users: [CurrentUser.user!, currentUser!])) { result in
            switch result {
            case .success(let conversation):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.goToChat(conversation: conversation!)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func goToChat(conversation: Conversation) {
        let conversationViewController = ConversationViewController(channel: conversation)
        self.navigationItem.title = ""
        navigationController?.pushViewController(conversationViewController!, animated: true)
    }
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        configureActivityIndicator()
        configureData()
        configureTextViewHintText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSubviews()
        configureTextView()
    }

    func setUser(user: User) {
        currentUser = user
    }
    
    func setEmail(email: String) {
        userEmail = email
    }
    
    private func configureUser() {
        if currentUser != nil {
            configureData()
        } else {
            makeRequest()
        }
    }
    
    private func makeRequest() {
        Api.shared.getUserByEmail(email: userEmail!) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.currentUser = user
                    self.configureData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                        self.showFailAlert()
                }
            }
        }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        successAlert.addAction(UIAlertAction(title: "Повторить попытку", style: UIAlertAction.Style.default) {_ in
            self.makeRequest()})
        present(successAlert, animated: true, completion: nil)
    }
    
    private func configureData() {
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
        setStars()
    }
    
    private func setStars() {
        star1.tintColor = .lightGray
        star2.tintColor = .lightGray
        star3.tintColor = .lightGray
        star4.tintColor = .lightGray
        star5.tintColor = .lightGray
        
        print(currentUser?.averageGrade)
        
        if currentUser!.averageGrade! > 0 && currentUser!.averageGrade! < 0.5{
            star1.image = withBottomHalfOverlayColor(myImage: star1.image!)
        }
        if currentUser!.averageGrade! > 0.5 {
            star1.tintColor = .systemYellow
        }
        if currentUser!.averageGrade! > 1 && currentUser!.averageGrade! < 1.5{
            star2.image = withBottomHalfOverlayColor(myImage: star2.image!)
        }
        if currentUser!.averageGrade! > 1.5 {
            star2.tintColor = .systemYellow
        }
        if currentUser!.averageGrade! > 2 &&  currentUser!.averageGrade! < 2.5 {
            star3.image = withBottomHalfOverlayColor(myImage: star3.image!)
        }
        if currentUser!.averageGrade! > 2.5 {
             star3.tintColor = .systemYellow
        }
        if currentUser!.averageGrade! > 3 && currentUser!.averageGrade! < 3.5 {
            star4.image = withBottomHalfOverlayColor(myImage: star4.image!)
        }
        if currentUser!.averageGrade! > 3.5 {
            star4.tintColor = .systemYellow
        }
        if currentUser!.averageGrade! > 4 && currentUser!.averageGrade! < 4.5 {
            star5.image = withBottomHalfOverlayColor(myImage: star5.image!)
        }
        if currentUser!.averageGrade! > 4.5 {
            star5.tintColor = .systemYellow
        }
    }
    
    func withBottomHalfOverlayColor(myImage: UIImage) -> UIImage
      {
        let rect = CGRect(x: 0, y: 0, width: myImage.size.width, height: myImage.size.height)


        UIGraphicsBeginImageContextWithOptions(myImage.size, false, myImage.scale)
        myImage.draw(in: rect)

        let context = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)

        context.setFillColor(UIColor.systemYellow.cgColor)

        let rectToFill = CGRect(x: 0, y: 0, width: myImage.size.width * 0.5, height: myImage.size.height)
        context.fill(rectToFill)
          
          context.setFillColor(UIColor.lightGray.cgColor)
          let rectToFill2 = CGRect(x: myImage.size.width * 0.5, y: 0, width: myImage.size.width * 0.5, height: myImage.size.height)
          context.fill(rectToFill2)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
        if aboutMeTextView.text.isEmpty || aboutMeTextView.textColor == .black {
            aboutMeTextView.text = "Нет информации"
            aboutMeTextView.textColor = .lightGray
        }
    }
    
    private func configureSubviews() {
        configureProfileImageView()
        configureButtons()
        EnterViewController.isEnglish ? translateToEnglish() : translateToRussia()
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    
    private func configureButtons() {
        canButton.makeButtonOval()
        wantButton.makeButtonOval()
    }
    
    private func configureTextView() {
        aboutMeTextView.layer.borderWidth = 0.5
        aboutMeTextView.layer.borderColor = CGColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        aboutMeTextView.layer.cornerRadius = 10
    }
    
    private func goToPersonalSkillList(skillStatus: Int) {
        let storyboard = UIStoryboard(name: "PersonalSkillList", bundle: nil)
        let personalSkillListViewController = storyboard.instantiateViewController(withIdentifier: "PersonalSkillList") as! PersonalSkillListViewController
        personalSkillListViewController.skillStatus = skillStatus
        personalSkillListViewController.userEmail = currentUser?.mail
        navigationController?.pushViewController(personalSkillListViewController, animated: true)
    }
    
    enum Const {
        static let buttonBorderRadius: CGFloat = 14
        static let maxNumOfCharsInName = 16
    }
}

extension ForeignProfileViewController {
    
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
        translateProfileView(isEnglish: false)
    }
    
    private func translateToEnglish() {
        translateProfileView(isEnglish: true)
    }
    
    private func translateProfileView(isEnglish: Bool) {
        if (isEnglish) {
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
        } else {
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
        }
    }
}
