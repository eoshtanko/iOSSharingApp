//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Екатерина on 07.03.2022.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    private let channel: Conversation?

    var entreMessageBar: EntryMessageView?
    var hightOfKeyboard: CGFloat?
    
    init?(channel: Conversation?) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        registerKeyboardNotifications()
        configureTapGestureRecognizer()
        scrollToBottom(animated: false)
    }
    
    private func showFailToLoadMessagesAlert() {
        let failureAlert = UIAlertController(title: "Ошибка",
                                             message: "Не удалось загрузить сообщения.",
                                             preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "OK",
                                             style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Повторить",
                                             style: UIAlertAction.Style.cancel) {_ in
            // self.configureSnapshotListener()
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
    //    navigationItem.title = channel?.name
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
