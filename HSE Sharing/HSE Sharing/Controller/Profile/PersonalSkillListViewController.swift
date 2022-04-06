import UIKit

class PersonalSkillListViewController: UIViewController {
    
    static var isContainedCanSkills = true
    private var skills: [Skill] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSkills()
        configureNavigationBar()
        configureTableView()
        configureNavigationButton()
        configureImage()
    }
    
    private func configureSkills() {
        if (PersonalSkillListViewController.isContainedCanSkills) {
            skills = Api.canSkills
        }
    }
    
    private func configureNavigationButton() {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.imageView?.tintColor = .systemBlue
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.imageView?.clipsToBounds = true
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BlueLightColor")
        if PersonalSkillListViewController.isContainedCanSkills {
            navigationItem.title = ProfileViewController.isEnglish ? "Can" : "Могу"
        } else {
            navigationItem.title = ProfileViewController.isEnglish ? "Want" : "Хочу"
        }
    }
    
    private func showConfirmDeletingAlert() {
        let failureAlert = UIAlertController(
            title: ProfileViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите удалить?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive) {_ in
            //self.configureSnapshotListener()
        })
        present(failureAlert, animated: true, completion: nil)
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
        personalSkillCell.setEditSkillAction(nil)
        personalSkillCell.setDeleteSkillAction(showConfirmDeletingAlert)
        return personalSkillCell
    }
}
