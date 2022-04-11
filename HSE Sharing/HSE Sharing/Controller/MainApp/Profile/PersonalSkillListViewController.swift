import UIKit

class PersonalSkillListViewController: UIViewController {
    
    static var isContainedCanSkills = true
    private var skills: [Skill] = [] {
        didSet {
            tableView.isHidden = skills.isEmpty
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationButton()
        configureImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func setSkills(skills: [Skill]?) {
        self.skills = skills ?? []
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
        if (PersonalSkillListViewController.isContainedCanSkills) {
            imageView.image = UIImage(named: "crowCosmonautLeft")
        } else {
            imageView.image = UIImage(named: "crowCosmonautRight")
        }
    }
    
    private func configureTableView() {
        if(skills.count != 0) {
            tableView.register(
                UINib(nibName: String(describing: PersonalSkillCell.self), bundle: nil),
                forCellReuseIdentifier: PersonalSkillCell.identifier
            )
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private func configureNavigationBar() {
        if PersonalSkillListViewController.isContainedCanSkills {
            navigationItem.title = EnterViewController.isEnglish ? "Can" : "Могу"
        } else {
            navigationItem.title = EnterViewController.isEnglish ? "Want" : "Хочу"
        }
    }
    
    private func showConfirmDeletingAlert() {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите удалить?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive) {_ in
            //self.configureSnapshotListener()
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    @objc private func createSkill() {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "SkillEditScreen", bundle: nil)
        let skillEditViewController = storyboard.instantiateViewController(withIdentifier: "SkillEditScreen") as! SkillEditViewController
        navigationController?.pushViewController(skillEditViewController, animated: true)
    }
    
    private func editSkill(_ skill: Skill) {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "SkillEditScreen", bundle: nil)
        let skillEditViewController = storyboard.instantiateViewController(withIdentifier: "SkillEditScreen") as! SkillEditViewController
        skillEditViewController.setSkill(skill)
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
