import UIKit

class PersonalSkillListViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView!
    
    var skillStatus: Int!
    var userEmail: String!
    private var skills: [Skill] = [] {
        didSet {
            if tableView != nil {
                tableView.isHidden = skills.isEmpty
                view.backgroundColor = skills.isEmpty ? UIColor(named: "BlueLightColor") : .white
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func unwindToPersonalSkillListViewController(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureTableView()
        tableView.isHidden = true
        loadSkillsRequest()
        if userEmail == CurrentUser.user.mail {
            configureNavigationButton()
        }
        configureImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = skills.isEmpty ? UIColor(named: "BlueLightColor") : .white
        configureNavigationBar()
        if userEmail == CurrentUser.user.mail {
            configureSkills()
        }
    }
    
    private func loadSkillsRequest() {
        activityIndicator.startAnimating()
        Api.shared.getSkillsOfSpecificUser(email: userEmail) { result in
            switch result {
            case .success(let skills):
                DispatchQueue.main.async {
                    CurrentUser.user.skills = skills
                    self.skills = (skills?.filter { skill in
                        return skill.status == self.skillStatus
                    })!
                    self.tableView.reloadData()
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
    
    func configureSkills() {
        skills = CurrentUser.user.skills!.filter { skill in
            return skill.status == skillStatus
        }
        tableView.reloadData()
    }
    
    private func configureNavigationButton() {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.imageView?.tintColor = .systemBlue
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.imageView?.clipsToBounds = true
        addButton.addTarget(self, action: #selector(createSkill), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func configureImage() {
        if (skillStatus == 1) {
            imageView.image = UIImage(named: "crowCosmonautLeft")
        } else {
            imageView.image = UIImage(named: "crowCosmonautRight")
        }
    }
    
    private func configureTableView() {
            tableView.register(
                UINib(nibName: String(describing: PersonalSkillCell.self), bundle: nil),
                forCellReuseIdentifier: PersonalSkillCell.identifier
            )
            tableView.dataSource = self
            tableView.delegate = self
        tableView.isHidden = skills.isEmpty
    }
    
    private func configureNavigationBar() {
        if skillStatus == 1 {
            navigationItem.title = EnterViewController.isEnglish ? "Can" : "Могу"
        } else {
            navigationItem.title = EnterViewController.isEnglish ? "Want" : "Хочу"
        }
    }
    
    private func showConfirmDeletingAlert(id: Int64) {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите удалить?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive) {_ in
            self.deleteSkillRequest(id: id)
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    private func deleteSkillRequest(id: Int64) {
        activityIndicator.startAnimating()
        Api.shared.deleteSkill(id: id) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.configureSkills()
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
    
    @objc private func createSkill() {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "SkillEditScreen", bundle: nil)
        let skillEditViewController = storyboard.instantiateViewController(withIdentifier: "SkillEditScreen") as! SkillEditViewController
        skillEditViewController.isCanSkill = skillStatus == 1
        navigationController?.pushViewController(skillEditViewController, animated: true)
    }
    
    private func editSkill(_ skill: Skill) {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "SkillEditScreen", bundle: nil)
        let skillEditViewController = storyboard.instantiateViewController(withIdentifier: "SkillEditScreen") as! SkillEditViewController
        skillEditViewController.setSkill(skill)
        skillEditViewController.isCanSkill = skillStatus == 1
        navigationController?.pushViewController(skillEditViewController, animated: true)
    }
}

extension PersonalSkillListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonalSkillListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: PersonalSkillCell.identifier, for: indexPath)
        guard let personalSkillCell = cell as? PersonalSkillCell else {
            return cell
        }
        let skill = skills[indexPath.row]
        personalSkillCell.configureCell(skill)
        personalSkillCell.setEditSkillAction(editSkill)
        personalSkillCell.setDeleteSkillAction(showConfirmDeletingAlert)
        return personalSkillCell
    }
}
