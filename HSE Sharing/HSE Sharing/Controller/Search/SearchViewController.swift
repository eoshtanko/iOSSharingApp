//
//  SearchController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = UISearchBar()
    
    private var skills: [Skill] = []
    private var filteredSkills: [Skill]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skills = []
        filteredSkills = skills
        configureView()
        configureTableView()
        configureNavigationBar()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        tableView.register(
            UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: ConversationTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        configureTableViewAppearance()
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
        configureNavigationTitle()
        configureNavigationButton()
    }
    
    private func configureNavigationTitle() {
        navigationItem.title = ProfileViewController.isEnglish ? "Skills search" : "Поиск навыков"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureNavigationButton() {
//        let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: Const.sizeOfNavigationButton,
//                                                   height: Const.sizeOfNavigationButton))
//        setImageToNavigationButton(profileButton)
//        profileButton.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationTableViewCell.identifier,
            for: indexPath)
        guard let conversationCell = cell as? ConversationTableViewCell else {
            return cell
        }
//        let conversation = indexPath.section == 0 ? filteredOnlineConversations[indexPath.row] : filteredOfflineConversations[indexPath.row]
//        conversationCell.configureCell(conversation)
        return conversationCell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.enablesReturnKeyAutomatically = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSkills = searchText.isEmpty ? skills : skills.filter {
            (item: Skill) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

