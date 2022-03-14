//
//  PersonalSkillListViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 13.03.2022.
//

import UIKit

class PersonalSkillListViewController: UIViewController {
    
    static var isContainedCanSkills = true
    private var skills: [Skill] = []
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureNavigationButton()
        configureImage()
        configureSkills()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTableView()
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
            view.addSubview(tableView)
            configureTableViewAppearance()
        }
    }
    
    private func configureTableViewAppearance() {
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationBar() {
        if PersonalSkillListViewController.isContainedCanSkills {
            navigationItem.title = ProfileViewController.isEnglish ? "Can" : "Могу"
        } else {
            navigationItem.title = ProfileViewController.isEnglish ? "Want" : "Хочу"
        }
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
        return personalSkillCell
    }
}

