//
//  CommentsViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController {
    
    private var comments: [Feedback] = [] {
        didSet {
            if tableView != nil {
                tableView.isHidden = comments.isEmpty
                view.backgroundColor = comments.isEmpty ? UIColor(named: "BlueLightColor") : .white
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comments = [Feedback(id: 1, gade: 4, comment: "Опоздал на встречу, но в остальном все хорошо.", senderMail: "", receiverMail: "")]
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func setComments(comments: [Feedback]?) {
       // self.comments = comments ?? []
    }
    
    private func configureTableView() {
            tableView.register(
                UINib(nibName: String(describing: CommentCell.self), bundle: nil),
                forCellReuseIdentifier: CommentCell.identifier
            )
            tableView.dataSource = self
            tableView.delegate = self
        tableView.isHidden = comments.isEmpty
    }
    
    private func configureNavigationBar() {
            navigationItem.title = EnterViewController.isEnglish ? "Comments" : "Комментарии"
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
    
}

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: CommentCell.identifier, for: indexPath)
        guard let commentCell = cell as? CommentCell else {
            return cell
        }
        let comment = comments[indexPath.row]
        commentCell.configureCell(comment)
        commentCell.setDeleteCommentAction(showConfirmDeletingAlert)
        return commentCell
    }
}
