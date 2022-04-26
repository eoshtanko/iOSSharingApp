//
//  CommentsViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView!
    var userMail: String!
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
        configureActivityIndicator()
        configureTableView()
        loadCommentsRequest()
    }
    
    private func loadCommentsRequest() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.getFeetbacksOfSpecificUser(email: self.userMail) { result in
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments!
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
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: (EnterViewController.isEnglish ? "Network error" : "Ошибка сети"), message: (EnterViewController.isEnglish ? "Check the internet." : "Проверьте интернет."), preferredStyle: UIAlertController.Style.alert)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
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
    
    private func showConfirmDeletingAlert(comment: Feedback) {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите удалить?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Cancel" : "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Delete" : "Удалить", style: UIAlertAction.Style.destructive) {_ in
            if CurrentUser.user.isModer! {
                self.deleteCommentModer(comment: comment)
            } else {
                self.deleteCommentUser(comment: comment)
            }
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    private func deleteCommentModer(comment: Feedback) {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        Api.shared.deleteFeetbackModer(id: comment.id) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.loadCommentsRequest()
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
    
    private func deleteCommentUser(comment: Feedback) {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        Api.shared.deleteFeetbackUser(id: comment.id) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.loadCommentsRequest()
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
