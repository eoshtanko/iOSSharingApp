//
//  CompletedExchangesViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 16.04.2022.
//

import UIKit

class CompletedExchangesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let settingsButton = UIButton()
    private var activityIndicator: UIActivityIndicatorView!
    
    private var transactions: [Transaction] = [] {
        didSet {
            if tableView != nil {
                tableView.isHidden = transactions.isEmpty
                view.backgroundColor = transactions.isEmpty ? UIColor(named: "BlueLightColor") : .white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureTableView()
        makeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
    }
    
    private func makeRequest() {
        activityIndicator.startAnimating()
        Api.shared.getTransactions(type: .completed) { result in
            switch result {
            case .success(let transactions):
                DispatchQueue.main.async {
                    if let transactions = transactions {
                        self.transactions = transactions
                    } else {
                        self.transactions = []
                    }
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.transactions = [Transaction(id: 1, skill1: "Помощь с уборкой", skill2: "Монтаж видео", description: "", senderMail: "", receiverMail: "", whoWantMail: "", status: 0, users: [])]
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Проверьте интернет.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
            self.performSegue(withIdentifier: "unwindToExchanges", sender: nil)
        })
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
    
    private func configureTableView() {
        tableView.register(
            UINib(nibName: String(describing: СompletedExchangeCell.self), bundle: nil),
            forCellReuseIdentifier: СompletedExchangeCell.identifier
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
        navigationItem.title = EnterViewController.isEnglish ? "Current exchanges" : "Завершенные"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CompletedExchangesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CompletedExchangesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: СompletedExchangeCell.identifier,
            for: indexPath)
        guard let transactionCell = cell as? СompletedExchangeCell else {
            return cell
        }
        let transaction = transactions[indexPath.row]
        transactionCell.configureCell(transaction, imageTapped)
        return transactionCell
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer, transaction: Transaction, user: User?)
    {
        guard let user = user else {
            return
        }
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "ForeignProfile", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ForeignProfile") as! ForeignProfileViewController
        profileViewController.setUser(user: user)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
