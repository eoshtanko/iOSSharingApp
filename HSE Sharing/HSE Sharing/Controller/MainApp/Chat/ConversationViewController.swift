//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Екатерина on 07.03.2022.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    let channel: Conversation?
    private var activityIndicator: UIActivityIndicatorView!
    
    var entreMessageBar: EntryMessageView?
    var hightOfKeyboard: CGFloat?
    
    var messages: [Message]? = []
    
    init?(channel: Conversation?) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        loadMessages()
        configureMessageReceiving()
        configureTableView()
        configureNavigationBar()
        registerKeyboardNotifications()
        configureTapGestureRecognizer()
        scrollToBottom(animated: false)
    }
    
    private func configureMessageReceiving() {
        Api.shared.handleMessage = self.handleMessage
    }
    
    private func handleMessage(message: Message) {
        if message.senderMail == (CurrentUser.user.mail == channel?.mail1 ? channel?.mail2 : channel?.mail1) {
            messages?.append(message)
            tableView.reloadData()
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        let yoffset = view.frame.midY // - 60
        activityIndicator.center = CGPoint(x: view.frame.midX, y: yoffset)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        tableView.addSubview(activityIndicator)
    }
    
    private func loadMessages() {
     // activityIndicator.startAnimating()
        Api.shared.getMessages(email: channel?.mail1 == CurrentUser.user.mail ? (channel?.mail2)! : (channel?.mail1)! , id: 0) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages
                    self.tableView.reloadData()
                    self.scrollToBottom(animated: false)
                    self.activityIndicator.stopAnimating()
                    self.scrollToBottom(animated: false)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailToLoadMessagesAlert()
                }
            }
        }
    }
    
    private func showFailToLoadMessagesAlert() {
        let failureAlert = UIAlertController(title: "Ошибка",
                                             message: "Не удалось загрузить сообщения.",
                                             preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "OK",
                                             style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Повторить",
                                             style: UIAlertAction.Style.cancel) {_ in
            self.loadMessages()
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    
    private func configureTapGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        entreMessageBar?.textView.resignFirstResponder()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = channel?.mail1 == CurrentUser.user.mail ? channel?.name2 : channel?.name1
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTableView() {
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        if isScrollingNecessary() {
            let bottomOffset = entreMessageBar?.textView.isFirstResponder ?? false ? bottomOffsetWithKeyboard() : bottomOffsetWithoutKeyboard()
            
            tableView.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    private func isScrollingNecessary() -> Bool {
        let bottomOffset = entreMessageBar?.textView.isFirstResponder ?? false ? hightOfKeyboard : entreMessageBar?.bounds.size.height
        return tableView.contentSize.height > tableView.bounds.size.height - (bottomOffset ?? 0) - Const.empiricalValue
    }
    
    private func bottomOffsetWithKeyboard() -> CGPoint {
        return CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height + (hightOfKeyboard ?? 0))
    }
    
    private func bottomOffsetWithoutKeyboard() -> CGPoint {
        return CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height + (entreMessageBar?.bounds.size.height ?? 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Const {
        static let dataModelName = "Chat"
        static let estimatedRowHeight: CGFloat = 60
        static let heightOfHeader: CGFloat = 50
        static let empiricalValue: CGFloat = 70
    }
}
