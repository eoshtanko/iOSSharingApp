//
//  ConversationsListViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = UISearchBar()
    
    private let onlineConversations = Api.getOnlineConversations()
    private let offlineConversations = Api.getOfflineConversations()
    private var filteredOnlineConversations: [Conversation]!
    private var filteredOfflineConversations: [Conversation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredOnlineConversations = onlineConversations
        filteredOfflineConversations = offlineConversations
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
    }
    
    private func configureNavigationTitle() {
        navigationItem.title = ProfileViewController.isEnglish ? "Chat" : "Переписки"
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
        let conversation = indexPath.section == 0 ? filteredOnlineConversations[indexPath.row] : filteredOfflineConversations[indexPath.row]
        setupConversationsBeforePushViewController(conversation)
        
        let conversationViewController = ConversationViewController()
        conversationViewController.conversation = conversation
        
        self.navigationItem.title = ""
        navigationController?.pushViewController(conversationViewController, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.hightOfCell
    }
    
    private func setupConversationsBeforePushViewController(_ conversation: Conversation) {
        conversation.hasUnreadMessages = false
        if (conversation.message != nil) {
            Api.lastMessage = ChatMessage(text: conversation.message, isIncoming: true, date: conversation.date)
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Const.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return filteredOnlineConversations.count
        } else {
            return filteredOfflineConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationTableViewCell.identifier,
            for: indexPath)
        guard let conversationCell = cell as? ConversationTableViewCell else {
            return cell
        }
        let conversation = indexPath.section == 0 ? filteredOnlineConversations[indexPath.row] : filteredOfflineConversations[indexPath.row]
        conversationCell.configureCell(conversation)
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? ProfileViewController.isEnglish ? "Online" : "Онлайн" :
        ProfileViewController.isEnglish ? "History" : "История"
    }
}

// Подумала, будет плюсом :)
extension ConversationsListViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.enablesReturnKeyAutomatically = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredOnlineConversations = searchText.isEmpty ? onlineConversations : onlineConversations.filter {
            (item: Conversation) -> Bool in
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        filteredOfflineConversations = searchText.isEmpty ? offlineConversations : offlineConversations.filter {
            (item: Conversation) -> Bool in
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
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
