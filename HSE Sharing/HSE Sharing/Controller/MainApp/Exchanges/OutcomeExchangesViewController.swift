//
//  OutcomeExchangesViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 16.04.2022.
//

import UIKit

class OutcomeExchangesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindOutcomeExchangesViewController(segue:UIStoryboardSegue) { }
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
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
    }
    
    private func makeRequest() {
        activityIndicator.startAnimating()
        Api.shared.getTransactions(type: .out) { result in
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
            UINib(nibName: String(describing: OutcomeExchangeCell.self), bundle: nil),
            forCellReuseIdentifier: OutcomeExchangeCell.identifier
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
        navigationItem.title = EnterViewController.isEnglish ? "Current exchanges" : "Исходящие"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension OutcomeExchangesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OutcomeExchangesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OutcomeExchangeCell.identifier,
            for: indexPath)
        guard let transactionCell = cell as? OutcomeExchangeCell else {
            return cell
        }
        let transaction = transactions[indexPath.row]
        transactionCell.configureCell(transaction, delete: showConfirmDeleteAlert, edit: edit, imageTapped)
        return transactionCell
    }
    
    private func showConfirmDeleteAlert(transaction: Transaction) {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to delete it?" : "Уверены, что хотите отказаться от обмена?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: "Отказаться", style: UIAlertAction.Style.destructive) {_ in
            self.delete(transaction: transaction)
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    private func delete(transaction: Transaction) {
        activityIndicator.startAnimating()
        Api.shared.deleteTransaction(transaction: transaction, sendNotification: false) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.makeRequest()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
    
    private func edit(transaction: Transaction) {
        self.navigationItem.title = ""
        let storyboard = UIStoryboard(name: "EditExchangeScreen", bundle: nil)
        let editExchangeScreen = storyboard.instantiateViewController(withIdentifier: "EditExchangeScreen") as! EditExchangeViewController
        editExchangeScreen.setExchange(transaction: transaction)
        navigationController?.pushViewController(editExchangeScreen, animated: true)
    }
    
    private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer, transaction: Transaction, user: User?)
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

