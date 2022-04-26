//
//  ForeignPersonalSkillListViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 24.04.2022.
//

import UIKit

class ForeignPersonalSkillListViewController: UIViewController {
    
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
    
    @IBAction func unwindToForeignPersonalSkillListViewController(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureTableView()
        tableView.isHidden = true
        loadSkillsRequest()
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
        self.view.isUserInteractionEnabled = false
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
                    self.view.isUserInteractionEnabled = true
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
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
    
    private func configureImage() {
        if (skillStatus == 1) {
            imageView.image = UIImage(named: "crowCosmonautLeft")
        } else {
            imageView.image = UIImage(named: "crowCosmonautRight")
        }
    }
    
    private func configureTableView() {
            tableView.register(
                UINib(nibName: String(describing: SearchSkillCell.self), bundle: nil),
                forCellReuseIdentifier: SearchSkillCell.identifier
            )
            tableView.dataSource = self
            tableView.delegate = self
        tableView.isHidden = skills.isEmpty
    }
    
    private func configureNavigationBar() {
        if skillStatus == 1 {
            navigationItem.title = EnterViewController.isEnglish ? "Can" : "Может"
        } else {
            navigationItem.title = EnterViewController.isEnglish ? "Want" : "Хочет"
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
}

extension ForeignPersonalSkillListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ForeignPersonalSkillListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: SearchSkillCell.identifier, for: indexPath)
        guard let personalSkillCell = cell as? SearchSkillCell else {
            return cell
        }
        let skill = skills[indexPath.row]
        personalSkillCell.configureCell(skill, nil, { skill in
            self.createNewTransaction(skill: skill)
        })
        return personalSkillCell
    }
    
    private func createNewTransaction(skill: Skill) {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "NewExchangeScreen", bundle: nil)
        let newExchangeScreen = storyboard.instantiateViewController(withIdentifier: "NewExchangeScreen") as! NewExchangeViewController
        newExchangeScreen.setSkill(skill: skill)
        newExchangeScreen.fromSearch = false
        navigationController?.pushViewController(newExchangeScreen, animated: true)
    }
}

