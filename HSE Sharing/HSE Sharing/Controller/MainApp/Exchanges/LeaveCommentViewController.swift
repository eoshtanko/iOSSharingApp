//
//  LeaveCommentViewController.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import Foundation
import UIKit

class LeaveCommentViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentSpace: UITextView!
    
    private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var anotherUserMail: String!
    var grade = 0
    
    @IBAction func saveButtonAction(_ sender: Any) {
        createRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStars()
        configureActivityIndicator()
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(activityIndicator)
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.makeButtonOval()
        commentSpace.layer.cornerRadius = 10
    }
    
    private func setStars() {
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        star1.isUserInteractionEnabled = true
        star1.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        star2.isUserInteractionEnabled = true
        star2.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        star3.isUserInteractionEnabled = true
        star3.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped4(tapGestureRecognizer:)))
        star4.isUserInteractionEnabled = true
        star4.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(imageTapped5(tapGestureRecognizer:)))
        star5.isUserInteractionEnabled = true
        star5.addGestureRecognizer(tapGestureRecognizer5)
        
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if ( star1.tintColor == .systemYellow && star2.tintColor == .lightGray &&  star3.tintColor == .lightGray && star4.tintColor == .lightGray && star5.tintColor == .lightGray) {
            star1.tintColor = .lightGray
            star2.tintColor = .lightGray
            star3.tintColor = .lightGray
            star4.tintColor = .lightGray
            star5.tintColor = .lightGray
            grade = 0
        } else {
            star1.tintColor = .systemYellow
            star2.tintColor = .lightGray
            star3.tintColor = .lightGray
            star4.tintColor = .lightGray
            star5.tintColor = .lightGray
            grade = 1
        }
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer)
    {
        star1.tintColor = .systemYellow
        star2.tintColor = .systemYellow
        star3.tintColor = .lightGray
        star4.tintColor = .lightGray
        star5.tintColor = .lightGray
        grade = 2
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer)
    {
        star1.tintColor = .systemYellow
        star2.tintColor = .systemYellow
        star3.tintColor = .systemYellow
        star4.tintColor = .lightGray
        star5.tintColor = .lightGray
        grade = 3
    }
    
    @objc func imageTapped4(tapGestureRecognizer: UITapGestureRecognizer)
    {
        star1.tintColor = .systemYellow
        star2.tintColor = .systemYellow
        star3.tintColor = .systemYellow
        star4.tintColor = .systemYellow
        star5.tintColor = .lightGray
        grade = 4
    }
    
    @objc func imageTapped5(tapGestureRecognizer: UITapGestureRecognizer)
    {
        star1.tintColor = .systemYellow
        star2.tintColor = .systemYellow
        star3.tintColor = .systemYellow
        star4.tintColor = .systemYellow
        star5.tintColor = .systemYellow
        grade = 5
    }
    
    private func showFailAlert() {
        let successAlert = UIAlertController(title: "Ошибка сети", message: "Данные не были сохранены. Проверьте интернет и попробуйте снова.", preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(successAlert, animated: true, completion: nil)
    }
    
    private func createRequest() {
        
        let feedback = Feedback(id: 0, grade: grade, comment: commentSpace.text ?? "", senderMail: CurrentUser.user.mail!, receiverMail: anotherUserMail)
        
        activityIndicator.startAnimating()
        Api.shared.createFeedback(feedback: feedback) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "unwindToExchanges", sender: nil)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFailAlert()
                }
            }
        }
    }
}
