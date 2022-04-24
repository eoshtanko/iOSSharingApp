//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Екатерина on 06.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = UISearchBar()
    private var activityIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    private var conversations: [Conversation]?
    private var filteredConversations: [Conversation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureView()
        configureTableView()
        configureNavigationBar()
        configureSearchBar()
        configurePullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
        loadConversationsRequest()
    }
    
    private func loadConversationsRequest() {
        activityIndicator.startAnimating()
        Api.shared.getConversations(email: CurrentUser.user.mail!) { result in
            switch result {
            case .success(let conversations):
                DispatchQueue.main.async {
                    self.conversations = conversations?.sorted()
                    self.filteredConversations = self.conversations
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

    private func configurePullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Updating")
        refreshControl.addTarget(self, action: #selector(makeRenewRequest), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func makeRenewRequest() {
        Api.shared.getConversations(email: CurrentUser.user.mail!) { result in
            switch result {
            case .success(let conversations):
                DispatchQueue.main.async {
                    self.conversations = conversations?.sorted()
                    self.filteredConversations = self.conversations
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        successAlert.addAction(UIAlertAction(title: "Повторить попытку", style: UIAlertAction.Style.default) {_ in
            self.loadConversationsRequest()})
        present(successAlert, animated: true, completion: nil)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        let yoffset = view.frame.midY * 0.72
        print(view.frame.midY)
        activityIndicator.center = CGPoint(x: view.frame.midX, y: yoffset)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        tableView.addSubview(activityIndicator)
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
        navigationItem.title = "Переписки"
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
        if let conversation = filteredConversations?[indexPath.row] {
            
            let conversationViewController = ConversationViewController(channel: conversation)
            self.navigationItem.title = ""
            navigationController?.pushViewController(conversationViewController!, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.hightOfCell
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredConversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ConversationTableViewCell.identifier,
            for: indexPath)
        guard let conversationCell = cell as? ConversationTableViewCell else {
            return cell
        }
        if let conversation = filteredConversations?[indexPath.row] {
            conversationCell.configureCell(conversation)
        }
        return conversationCell
    }
    
    private func showConfirmDeletingAlert(conversation: Conversation) {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите удалить?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive) {_ in
            self.deleteConversationRequest(conversation: conversation)
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    private func deleteConversationRequest(conversation: Conversation) {
        activityIndicator.startAnimating()
        Api.shared.deleteConversation(id: conversation.id) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.loadConversationsRequest()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let conversation = filteredConversations?[indexPath.row] {
            let action = UIContextualAction(style: .destructive,
                                            title: "Delete") { [weak self] (_, _, completionHandler) in
                
                self?.showConfirmDeletingAlert(conversation: conversation)
                completionHandler(true)
            }
            action.backgroundColor = .systemRed
            action.image = UIImage(named: "trash")
            return UISwipeActionsConfiguration(actions: [action])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
}

extension ConversationsListViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.enablesReturnKeyAutomatically = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let conversations = conversations {
            filteredConversations = searchText.isEmpty ? conversations : conversations.filter {
                (item: Conversation) -> Bool in
                let search = item.mail1 == CurrentUser.user.mail ? item.name2 : item.name1
                return search.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            tableView.reloadData()
        }
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
