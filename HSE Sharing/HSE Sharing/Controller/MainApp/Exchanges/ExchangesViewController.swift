//
//  ExchangesController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ExchangesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let pickerView = UIPickerView()
    private let settingsButton = UIButton()
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func unwindToExchangesViewController(segue:UIStoryboardSegue) { }
    
    private var transactions: [Transaction] = [] {
        didSet {
            if tableView != nil {
                tableView.isHidden = transactions.isEmpty
                view.backgroundColor = transactions.isEmpty ? UIColor(named: "BlueLightColor") : .white
                if transactions.isEmpty {
                    view.addSubview(activityIndicator)
                    let yoffset = view.frame.midY
                    activityIndicator.center = CGPoint(x: view.frame.midX, y: yoffset)
                } else {
                    tableView.addSubview(activityIndicator)
                    let yoffset = view.frame.midY * 0.72
                    activityIndicator.center = CGPoint(x: view.frame.midX, y: yoffset)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureTableView()
        configureNavigationBar()
        configurePickerView()
        configurePickerAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
        makeRequest()
    }
    
    private func makeRequest() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        Api.shared.getTransactions(type: .active) { result in
            switch result {
            case .success(let transactions):
                DispatchQueue.main.async {
                    if let transactions = transactions {
                        self.transactions = transactions
                    } else {
                        self.transactions = []
                    }
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
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
    
    private func configureTableView() {
        tableView.register(
            UINib(nibName: String(describing: CurrentExchangeCell.self), bundle: nil),
            forCellReuseIdentifier: CurrentExchangeCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        view.addSubview(pickerView)
    }
    
    private func configurePickerAppearance() {
        pickerView.backgroundColor = UIColor(named: "BlueLightColor")
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        pickerView.frame.size = CGSize(width: pickerView.frame.size.width, height: 400)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationBar() {
        configureNavigationTitle()
        configureNavigationButton()
    }
    
    private func configureNavigationTitle() {
        navigationItem.title = EnterViewController.isEnglish ? "Current exchanges" : "Текущие обмены"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureNavigationButton() {
        settingsButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        settingsButton.imageView?.tintColor = .systemBlue
        settingsButton.contentHorizontalAlignment = .fill
        settingsButton.contentVerticalAlignment = .fill
        settingsButton.imageView?.contentMode = .scaleAspectFill
        settingsButton.imageView?.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(toggleRightPanel), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    @objc private func toggleRightPanel() {
        pickerView.isHidden = false
    }
}

extension ExchangesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExchangesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrentExchangeCell.identifier,
            for: indexPath)
        guard let transactionCell = cell as? CurrentExchangeCell else {
            return cell
        }
        let transaction = transactions[indexPath.row]
        transactionCell.configureCell(transaction, imageTapped) {
            self.showConfirmDeletingAlert(transaction: transaction)
        }
        return transactionCell
    }
    
    private func showConfirmDeletingAlert(transaction: Transaction) {
        let failureAlert = UIAlertController(
            title: EnterViewController.isEnglish ? "Are you sure you want to complete the exchange?" : "Уверены, что хотите завершить обмен?",
            message: nil,
            preferredStyle: UIAlertController.Style.alert)
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Cancel" : "Отмена", style: UIAlertAction.Style.default))
        failureAlert.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "Complete" : "Завершить", style: UIAlertAction.Style.destructive) {_ in
            self.complete(transaction: transaction)
        })
        present(failureAlert, animated: true, completion: nil)
    }
    
    private func complete(transaction: Transaction) {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let transaction = Transaction(id: transaction.id, skill1: transaction.skill1, skill2: transaction.skill2, description: transaction.description, senderMail: transaction.senderMail, receiverMail: transaction.receiverMail, whoWantMail: transaction.whoWantMail, status: 2, users: transaction.users)
        
        Api.shared.editTransaction(transaction: transaction) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.navigationItem.title = ""
                    let storyboard = UIStoryboard(name: "LeaveCommentScreen", bundle: nil)
                    let leaveCommentScreen = storyboard.instantiateViewController(withIdentifier: "LeaveCommentScreen") as! LeaveCommentViewController
                    leaveCommentScreen.anotherUserMail = transaction.receiverMail == CurrentUser.user.mail ? transaction.senderMail : transaction.receiverMail
                    self.navigationController?.pushViewController(leaveCommentScreen, animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
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

extension ExchangesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EnterViewController.isEnglish ? DataInEnglish.sectors.count - 1 : DataInRussian.sectors.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EnterViewController.isEnglish ? DataInEnglish.sectors[row] : DataInRussian.sectors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.navigationItem.title = ""
        switch row {
        case 0:
            let storyboard = UIStoryboard(name: "OutcomeExchanges", bundle: nil)
            let outcomeExchanges = storyboard.instantiateViewController(withIdentifier: "OutcomeExchanges") as! OutcomeExchangesViewController
            navigationController?.pushViewController(outcomeExchanges, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "IncomeExchanges", bundle: nil)
            let incomeExchanges = storyboard.instantiateViewController(withIdentifier: "IncomeExchanges") as! IncomeExchangesViewController
            navigationController?.pushViewController(incomeExchanges, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "CompletedExchanges", bundle: nil)
            let completedExchanges = storyboard.instantiateViewController(withIdentifier: "CompletedExchanges") as! CompletedExchangesViewController
            navigationController?.pushViewController(completedExchanges, animated: true)
        default:
            return
        }
        pickerView.isHidden = true
    }
}
