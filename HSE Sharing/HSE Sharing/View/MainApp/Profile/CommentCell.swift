//
//  CommentCell.swift
//  HSE Sharing
//
//  Created by Екатерина on 09.04.2022.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let identifier = String(describing: CommentCell.self)
    private var deleteComment: (() -> Void)?
    private var canBeDeleted: Bool = false
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteComment?()
    }
    
    func setDeleteCommentAction(_ deleteComment: (() -> Void)?) {
        self.deleteComment = deleteComment
    }

    func configureCell(_ comment: Feedback) {
        setInitialDeleteSettings()
        configureLabelsLanguage()
        configureData(comment)
        configureView()
    }
    
    private func setInitialDeleteSettings() {
        canBeDeleted = false
       // deleteButton.isHidden = true
    }

    private func configureLabelsLanguage() {
//        nameLabel.text = EnterViewController.isEnglish ? "Skill:" : "Навык:"
//        descriptionLabel.text = EnterViewController.isEnglish ? "Description:" : "Описание:"
//        categoryLabel.text = EnterViewController.isEnglish ? "Category:" : "Категория:"
//        subcategoryLabel.text = EnterViewController.isEnglish ? "Subcategory:" : "Подкатегория:"
    }
    
    private func setCanBeDeleted() {
        canBeDeleted = true
       // deleteButton.isHidden = false
    }
    
    private func configureData(_ comment: Feedback) {
        commentText.text = comment.comment
        if comment.gade > 0 {
            star1.tintColor = .systemYellow
        }
        if comment.gade > 1 {
            star2.tintColor = .systemYellow
        }
        if comment.gade > 2 {
            star3.tintColor = .systemYellow
        }
        if comment.gade > 3 {
            star4.tintColor = .systemYellow
        }
        if comment.gade > 4 {
            star5.tintColor = .systemYellow
        }
    }
    
    private func configureView() {
        innerView.layer.cornerRadius = 10
        coloredView.layer.cornerRadius = 10
    }
}

