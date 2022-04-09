//
//  ConversationsListViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    static let tableView = UITableView(frame: .zero, style: .grouped)
    let searchBar = UISearchBar()
    var isSearching = false
    
    var channels: [Conversation] = []
    var filteredChannels: [Conversation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredChannels = channels
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
        ConversationsListViewController.tableView.register(
            UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: ConversationTableViewCell.identifier
        )
        ConversationsListViewController.tableView.dataSource = self
        ConversationsListViewController.tableView.delegate = self
        view.addSubview(ConversationsListViewController.tableView)
        configureTableViewAppearance()
    }
    
    private func configureTableViewAppearance() {
        NSLayoutConstraint.activate([
            ConversationsListViewController.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ConversationsListViewController.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            ConversationsListViewController.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ConversationsListViewController.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        ConversationsListViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationBar() {
        configureNavigationTitle()
    }
    
    private func configureNavigationTitle() {
        navigationItem.title = EnterViewController.isEnglish ? "Chat" : "Переписки"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private enum Const {
        static let numberOfSections = 2
        static let hightOfCell: CGFloat = 100
        static let sizeOfNavigationButton: CGFloat = 44
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = isSearching ? filteredChannels[indexPath.row] : channels[indexPath.row]
        self.navigationItem.title = ""
        
        let conversationViewController = ConversationViewController(conversation: conversation)
        navigationController?.pushViewController(conversationViewController, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Const.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredChannels.count : channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationTableViewCell.identifier,
            for: indexPath)
        guard let conversationCell = cell as? ConversationTableViewCell else {
            return cell
        }
        let conversation = isSearching ? filteredChannels[indexPath.row] : channels[indexPath.row]
        conversationCell.configureCell(conversation)
        return conversationCell
    }
}

extension ConversationsListViewController: UISearchBarDelegate {
    
    func configureSearchBar() {
        ConversationsListViewController.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.enablesReturnKeyAutomatically = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filteredChannels = searchText.isEmpty ? channels : channels.filter { (item: Conversation) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        ConversationsListViewController.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}


extension ConversationsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
