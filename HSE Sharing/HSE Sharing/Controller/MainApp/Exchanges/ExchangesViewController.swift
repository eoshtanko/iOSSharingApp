//
//  ExchangesController.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.03.2022.
//

import UIKit

class ExchangesViewController: UIViewController {
    
    static let tableView = UITableView(frame: .zero, style: .grouped)
    private let pickerView = UIPickerView()
    private let settingsButton = UIButton()
    private var activityIndicator: UIActivityIndicatorView!
    
    private var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureView()
        configureTableView()
        makeRequest()
        configureNavigationBar()
        configurePickerView()
        configurePickerAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationTitle()
    }
    
    private func makeRequest() {
        activityIndicator.startAnimating()
//        Api.shared.getUserByEmail(email: emailTextField.text!) { result in
//            switch result {
//            case .success(let skills):
//                CurrentUser.user = user
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    ExchangesViewController.tableView.reloadData()
//                }
//            case .failure(let apiError):
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    if apiError as! ApiError == ApiError.noSuchData {
//                        self.noSuchUserAlert()
//                    } else {
//                        self.showFailAlert()
//                    }
//                }
//            }
//        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        ExchangesViewController.tableView.register(
            UINib(nibName: String(describing: СompletedExchangeCell.self), bundle: nil),
            forCellReuseIdentifier: СompletedExchangeCell.identifier
        )
        ExchangesViewController.tableView.dataSource = self
        ExchangesViewController.tableView.delegate = self
        view.addSubview(ExchangesViewController.tableView)
        configureTableViewAppearance()
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
    
    private func configureTableViewAppearance() {
        ExchangesViewController.tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            ExchangesViewController.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ExchangesViewController.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            ExchangesViewController.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ExchangesViewController.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        ExchangesViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
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
            withIdentifier: СompletedExchangeCell.identifier,
            for: indexPath)
        guard let transactionCell = cell as? СompletedExchangeCell else {
            return cell
        }
        let transaction = transactions[indexPath.row]
        transactionCell.configureCell(transaction)
        return transactionCell
    }
}

extension ExchangesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EnterViewController.isEnglish ? DataInEnglish.sectors.count : DataInRussian.sectors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EnterViewController.isEnglish ? DataInEnglish.sectors[row] : DataInRussian.sectors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
    }
}
